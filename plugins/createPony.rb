# createPony.rb
# Author: natleyn
# Version: 0.1.0
# Returns the basic concept of a My Little Pony character.

module SurfBot; module Plugins
module CreatePony
	extend Discordrb::Commands::CommandContainer
	def self.filename; "createPony.rb"; end

	command(:pony,
		description: "hehehe",
		help_available: false
		) do |event|
		
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop; remove_command(:pony); end

end # CreatePony
end; end # Plugins; SurfBot
