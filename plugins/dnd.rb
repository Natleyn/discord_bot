# dnd.rb
# Author: natleyn
# Version: 1.0.0
# Chooses two attributes from Dungeons and Dragons to be a hypothetical character's high and low points.

module SurfBot; module Plugins
module DnD
	extend Discordrb::Commands::CommandContainer
	def self.filename; "dnd.rb"; end

	@@stats = [
		"strength",
		"dexterity",
		"constitution",
		"intelligence",
		"wisdom",
		"charisma",
	]

	def self.roll_stats()
		high = @@stats.sample
		lowList = @@stats.reject { |stat| stat == high }
		return [ high, lowList.sample ]
	end

	command(:dndstats,
		 description: 'Picks a high stat and low stat for a D&D character.'
		) do |event|
		event << "You should pick high %s and low %s!" % roll_stats
	end

	def self.clean_up; end

	def self.stop
		remove_command(:dndstats)
	end
end # DnD
end; end # Plugins; SurfBot
