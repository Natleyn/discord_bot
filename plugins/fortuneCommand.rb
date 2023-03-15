# fortuneCommand.rb
# Author: natleyn
# Version: 1.0.0
# Holds the commands for using fortune/random.

require_relative '../data/fortune'
require_relative '../surfInfo'

module SurfBot; module Plugins
module Fortune
	extend Discordrb::Commands::CommandContainer
	def self.filename; "fortuneCommand.rb"; end

	command(:random,
		description: "Pick from a comma-separated list of options. Can use ; to fit multiple lists into one command (i.e. `;random 1,2,3;a,b,c` => `2, a`)"
			) do |event|
		break if event.user.current_bot?
		options = event.message.content.slice((SurfBot.surf_cmd_prefix.length+7)..-1)
		event << "`#{pick_random_option(options)}`"
	end


	def self.clean_up; end
	def self.save_data; end
	def self.stop; remove_command(:fortune); end

end # Fortune
end; end # Plugins; SurfBot

