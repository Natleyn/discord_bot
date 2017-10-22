# basePlugin.rb
# author: natleyn
# Version 1.0.0
# An example plugin to base further plugins off of. 

# require treats directories as they are relative to the current working directory of surfBot.rb, not of the plugin file
# require_relative does the opposite: the directory of the plugin file is considered the CWD for the provided argument
require_relative '../surfBotInfo2.rb'

module SurfBot; module Plugins
module BasePlugin
	extend Discordrb::Commands::CommandContainer
	def self.filename; "basePlugin.rb"; end
	
	# all important data and functions go here

	# I tend to put variables in class instance vars for simpler access, though that means the 
	# data structures are more susceptible to changes that could break the plugin.
		
	def self.test
		"Testing base plugin"
	end

	command(:base_plugin,
		 description: "This is the basic plugin format"
			) do |event|
		# send back whatever the result of 'test' is to the channel the event came from
		event << test
	end

	# You can shorten these two functions to one line if they're not doing anything complex
	def self.clean_up
		# Clean instance vars here so 'load'ing this plugin doesn't add onto them
	end
	def self.stop
		remove_command(:base_plugin)
	end

end # BasePlugin
end; end # Plugins; SurfBot
