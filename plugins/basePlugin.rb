# BasePlugin
# Version 0.0.1
# An example plugin to base further plugins off of. 

# Treat directories as they are relative to the current working directory of surfBot.rb, not of the plugin.
require_relative '../surfBotInfo2.rb'

module SurfBot; module Plugins
module BasePlugin
	extend Discordrb::Commands::CommandContainer
	def self.filename; "basePlugin.rb"; end

	# all important data and functions go here
		
	def self.test
		"Testing base plugin"
	end

	def self.clean_up
		# Clean instance vars here so 'load'ing this plugin doesn't add onto them
	end

	def self.stop
		remove_command(:base_plugin)
	end

	command(:base_plugin,
		 description: "This is the basic plugin format"
			) do |event|
		event << test
	end

end # BasePlugin
end; end # Plugins; SurfBot
