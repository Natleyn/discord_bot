# testPlugin.rb
# Author: natleyn
# Version: n/a
# Testbed for various commands and whatnot. Nothing in here is permanent.

require_relative '../surfInfo'

module SurfBot; module Plugins
module Test
	extend Discordrb::Commands::CommandContainer
	def self.filename; "testPlugin.rb"; end

	command(:test, help_available: false) do |event|
		break unless event.user.id == SurfBot.sea_client_id
		event.respond "<:ohno:344329083641135118>"
	end
	

	command(:embedtest, help_available: false) do |event|
		break unless event.user.id == SurfBot.sea_client_id

		#embed = Discordrb::Webhooks::Embed.new
	
		#embed.initialize
		#embed.description = "Heckin' test!"
		#embed.add_field(name: '',value: "test",inline: true)
		#embedText = Discordrb::Webhooks::EmbedField.new
		#embedText.initialize(nil,"test",true)
		#embed << embedText
		#bot.send_message(event.channel.id, "", false, embed)
	
		#event.channel.send_embed("", embed)
		# this stuff works.
#		event.channel.send_embed("test") do |embed|
#			embed.colour = 0x0000FF
#			embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Sea")
#			embed.title = "test embed"
#		end
		event.channel.send_embed do |embed|
			embed.title = "What about this?"
			#embed.description = "Race: x\nClass: y\nAlignment: TN"
			embed.description = ""
			embed.description << "Race: x\n"
			embed.description << "Class: Y"
			embed.add_field(name: "Str", value: "10", inline: true)
			embed.add_field(name: "Dex", value: "10", inline: true)
			embed.add_field(name: "Con", value: "10", inline: true)
			embed.add_field(name: "Int", value: "10", inline: true)
			embed.add_field(name: "Wis", value: "10", inline: true)
			embed.add_field(name: "Cha", value: "10", inline: true)
		end
	end


	command(:mention,
		description: "Posts a temporary message with a mention, to correct phantom mentions."
		) do |event|
		event.send_temporary_message("#{event.user.mention}", 30.0)		
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop
		remove_command(:test)
		remove_command(:embedtest)
		remove_command(:mention)
	end

end # Test
end; end # Plugins; SurfBot
