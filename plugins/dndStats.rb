# dndStats.rb
# Author: natleyn
# Version: 1.0.1
# Chooses two attributes from Dungeons and Dragons to be a hypothetical character's high and low points.
# Changelog:
# 1.0.1
#  - Minor under-the-hood change.

module SurfBot; module Plugins
module DnDStats
	extend Discordrb::Commands::CommandContainer
	def self.filename; "dndStats.rb"; end

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
		low = (@@stats - [high]).sample
		return [ high, low ]
	end

	command(:dndstats,
		 description: 'Picks a high stat and low stat for a D&D character.'
		) do |event|
		event << "You should pick high %s and low %s!" % roll_stats
	end

	def self.clean_up; end
	def self.stop; remove_command(:dndstats); end

end # DnDStats
end; end # Plugins; SurfBot
