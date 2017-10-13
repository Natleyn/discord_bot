# surfBot2.rb
# author: natleyn
#
# Main file holding the core of SurfBot.
# You can add functionality by extending the bot with plugins placed in ./plugins/ 




require 'discordrb'

module SurfBot

	@log_messages_to_console = false

	version = "2.0.1"

	require_relative './surfBotInfo2'

	# initialize the bot
	@bot = Discordrb::Commands::CommandBot.new( token: @surf_client_token, client_id: @surf_client_token, prefix: @surf_cmd_prefix )
	def self.include!(module_name)
		@bot.include! module_name
	end


	################################### Plugin Manager Start ###################################

	# plugin_list[filename] => module_name
	@plugin_list = {}

	def self.include!(module_name)
		@bot.include!(module_name)
	end

	def self.init_plugins
		# First, require all plugin files ...
		Dir['./plugins/*'].each do |plugin_file|
			plugin_filename = plugin_file.scan(/\w+\.rb$/)
			print "Loading plugin #{plugin_filename}...  "
			begin
				raise StandardError if @plugin_list.include?(plugin_filename)
				load "#{plugin_file}"
				@plugin_list[plugin_filename] = ""
				# check plugin for stuff like name, version, description
				print "success."
			rescue LoadError
				print "LoadError:#{$!.backtrace[0].split(":")[1]}: loading #{plugin_file}: #{$!}. Skipping..."
			rescue StandardError
				print "StandardError:#{$!.backtrace[0].split(":")[1]}: loading #{plugin_file}: #{$!} Skipping..."
			end
			print "\n"
		end
		# ... and include all plugin modules (unloaded -> loaded)
		SurfBot::Plugins.constants.each do |module_name|
			begin
				current_module = Plugins.const_get(module_name)
				puts "Adding commands from #{current_module}..."
				#puts "Adding #{module_name} in #{Plugins.const_get(module_name).filename} to plugin list"
				include!( current_module )
				@plugin_list[current_module.filename] = current_module
			rescue
				puts "Error:#{module_name}:#{$!.backtrace[0].split(":")[1]}: #{$!}"
			end
		end
	end


	@bot.command(:load_plugin, help_available: false, min_args: 1, max_args: 1, usage: ";load_plugin <plugin_filename>") do |event, *args|
		plugin_filename = args[0]
		print "Attempting to load plugin #{plugin_filename}...  "
		begin
			plugin_path = "./plugins/#{plugin_filename}"
			# if the file is already loaded, cleanup first
			@plugin_list[plugin_filename].clean_up
			load plugin_path
			include!(@plugin_list[plugin_filename])
			puts "success."
			event << "Success."
		rescue
			puts "failed: #{$!}"
			event << "Failure."
		end
	end

	@bot.command(:stop_plugin, help_available: false, min_args: 1, max_args: 1, usage: ";stop_plugin <plugin_filename>") do |event, *args|
		plugin_file_name = args[0]
		print "Stopping plugin #{plugin_file_name}... "
		begin
			@plugin_list[plugin_file_name].stop
			puts "success."
			event << "Success."
		rescue
			puts "failed: #{$!}"
			event << "Failure."
		end
	end

	@bot.command(:list_plugins, help_available: false) do |event|
		list = "Plugins: "
		@plugin_list.each do |filename, module_name|
			list += "#{module_name}, "
		end
		event.respond list.slice(0..-3)
	end
	################################### Plugin Manager End ###################################





	################################### Admin Commands Start ###################################

	# say - get bot to say stuff in either the current channel (no number arg) or the channel provided by the admin
	@bot.command(:say, help_available: false) do |event, *args|
		break unless event.user.id == @sea_client_id
		break if args[0].nil?
		if(args[0] =~ /[0-9]+/)
			@bot.send_message(Integer(args[0]), event.message.to_s[24..-1])
		else
				event.respond event.message.to_s[5..-1]
		end
	end

	# swapname - Get bot to switch names
	@bot.command(:swapname, max_args: 1, help_available: false) do |event|
		break unless event.user.id == @sea_client_id 
		msg = event.message.to_s.slice((@surf_cmd_prefix.length+9)..-1)
		msg.strip! if !msg.nil?
		@bot.profile.name = (msg.nil?) ? @surf_name.capitalize : msg.strip
		event.respond "Swapping to #{@bot.profile.name}, my good pony."
	end
	# invite - Print out the invite link for SurfBot
	@bot.command(:invite, help_available: false) do |event|
		break unless event.user.id == @sea_client_id
		event.respond "https://discordapp.com/api/oauth2/authorize?client_id=#{@surf_client_id}&scope=bot&permissions=0"
	end
	# exit - shutdown bot
	@bot.command(:exit, help_available: false) do |event|
		break unless event.user.id == @sea_client_id 
		event.respond "Shutting down."
		@bot.stop
		exit_bool = true
	end
	# Chat-based shutdown
	@bot.message(contains: /[Ss]leep well.*#{@surf_name}.*/) do |event|
		break unless event.user.id == @sea_client_id 
		event.respond "You too, pony."
		@bot.stop
	end

	@bot.message(with_text: 'Ping!') do |event|
		event.respond 'Pong!'
	end
	################################### Admin Commands End ###################################


	# Logging messages to console
	@bot.message do |event|
		#break if event.user.id == $choosieID
		if !@derpi_ignored_users.include?(event.user.id)
			unless event.channel.type == 1
				server_name = event.channel.server.name
				channel_name = "#" + event.channel.name
			else
				server_name = "PM"
				channel_name = "@" + event.user.username
			end
			user_name = event.user.username
			the_message = event.message.to_s
			puts "<#{server_name}.#{channel_name}> #{user_name}: #{the_message}"
		end
	end if @log_messages_to_console


	# start it up!
	@bot.run :async
	
	# initialize plugins
	init_plugins

	# display when you arrive
	@entry_channels.each do |channel| ; @bot.send_message(channel, "Watashi ga kita!"); end

	# If you use :async, The bot will cease to run if you don't bot.sync after starting it 
	# asynchronously and you don't loop until something forces an exit
	@bot.sync

	at_exit do
		puts "I sleep."
	end
end
