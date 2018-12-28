# surfBot2.rb
# Author: natleyn
# Version: 2.0.3
# Main file holding the core of SurfBot.
# You can add functionality by extending the bot with plugins placed in ./plugins/ 
# Changelog:
# 2.0.3
# - removed duplicate code
# - added code to save data within all plugins


require 'discordrb'

module SurfBot

	@log_messages_to_console = true

	version = "2.0.1"

	require_relative './surfBotInfo2'

	# initialize the bot
	@bot = Discordrb::Commands::CommandBot.new( token: @surf_client_token, client_id: @surf_client_token, prefix: @surf_cmd_prefix )


	################################### Plugin Manager Start ###################################

	class DuplicatePluginError < StandardError
		def initialize(msg="Duplicate file in ./plugins"); super(msg); end
	end	

	# plugin_list[filename] => module_name
	@plugin_list = {}

	def self.include!(module_name)
		@bot.include!(module_name)
	end

	# Take plugins
	def self.init_plugins
		# First, require all plugin files ...
		puts "[Initializing found plugins...]"
		Dir['./plugins/*'].each do |plugin_file|
			plugin_filename = plugin_file.scan(/\w+\.rb$/)[0]
			print "Loading plugin #{plugin_filename}...  "
			begin
				raise DuplicatePluginError if @plugin_list.include?(plugin_filename)
				load "#{plugin_file}"
				@plugin_list[plugin_filename] = ""
				# TODO: check plugin for stuff like name, version, description
				print "success."
			rescue DuplicatePluginError, SyntaxError, LoadError, StandardError
				print "failed: #{$!} (#{$!.class})"
			end
			print "\n"
		end
		puts "[Plugins initialized. Loading modules...]"
		# ... and include all plugin modules (unloaded -> loaded)
		SurfBot::Plugins.constants.each do |module_name|
			begin
				current_module = Plugins.const_get(module_name)
				puts "Adding commands from #{current_module}..."
				#puts "Adding #{module_name} in #{Plugins.const_get(module_name).filename} to plugin list"
				include!( current_module )
				@plugin_list[current_module.filename] = current_module
			rescue StandardError, SyntaxError, LoadError
				puts "failed: #{$!} (#{$!.class})"
			end
		end
		puts "[Module loading complete.]"
	end


	@bot.command(   :plugin,
			help_available: false,
			min_args: 1,
			max_args: 3,
			usage: "#{SurfBot.surf_cmd_prefix}plugin list/load/save/stop <plugin name for load/stop, w/ save name optional>"
			) do |event, *args|
		break unless event.user.id == @sea_client_id
		begin
			plugin_filename = args[1]
			case args[0]
			when /load/i
				print "Attempting to load plugin #{plugin_filename}...  "
				plugin_path = "./plugins/#{plugin_filename}"
				# if the file is already loaded, cleanup first
				@plugin_list[plugin_filename].clean_up if @plugin_list.include?(plugin_filename)
				load plugin_path
				include!(@plugin_list[plugin_filename])
			when /save/i
				# TODO: save all plugin data
			when /stop/i
				print "Stopping plugin #{plugin_filename}... "
				@plugin_list[plugin_filename].stop
			when /list/i
				list = "Plugins:```\n"
				@plugin_list.each do |filename, module_name|
					list += "#{filename} => #{module_name.to_s.split("::")[2]}\n"
				end
				list += "```"
				event << list.slice(0..-1)
			else
				event << "Check usage"
			end
			puts "success." if !args[0].match? /list/i
			event << "Success." if !args[0].match? /list/i
		rescue StandardError, SyntaxError, LoadError
			puts "failed: #{$!} (#{$!.class})"
			event << "Failure."
		end
		
	end
	################################### Plugin Manager End ###################################





	################################### Admin Commands Start ###################################

	# say - get bot to say stuff in either the current channel (no number arg) or the channel provided by the admin
	@bot.command(:say, help_available: false) do |event, *args|
		break unless event.user.id == @sea_client_id
		break if args[0].nil?
		if(args[0].match? /^[0-9]+$/ )
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
		if !@ignored_users.include?(event.user.id)
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
	@entry_channels.each do |channel| ; @bot.send_temporary_message(channel, "Watashi ga kita!", 30.0); end

	# If you use :async, The bot will cease to run if you don't bot.sync after starting it 
	# asynchronously and you don't loop until something forces an exit
	@bot.sync

	at_exit do
		# Save all plugin data
		SurfBot::Plugins.constants.each do |module_name|
			Plugins.const_get(module_name).save_data
		end


		puts "I sleep."
	end
end
