# fallenLondon.rb
# Author: Natleyn
# Version: 0.0.1
# desc here
# 0.0.1
#  - Added function to calculate CP required to attain a certain level

module SurfBot; module Plugins
module FallenLondon
	extend Discordrb::Commands::CommandContainer
	def self.filename; "fallenLondon.rb"; end

	def self.calculate_cp_to_level(level)
		index = level
		sum = 0
		while index > 0 do
			sum = index + sum
			index = index - 1
		end
	end

	def self.calculate_cp_from_level_to_level(fromLvl, toLvl)
		index = fromLvl
		sum = 0
		while index < toLvl do
			index = index + 1
			sum = index > 70 ? 70 + sum : index + sum
		end
		"Sum of CP #{fromLvl != 0 ? "from level #{fromLvl} " : ""}to level #{toLvl}: #{sum}"
	end

	command(:fl,
		description: "Calculate CP required to attain a certain level, or from one level to another.",
		usage: "#{SurfBot.surf_cmd_prefix}cpToLvl [<fromLvl>-]<toLvl>"
		) do |event, *args|
		input = "#{args[0]}"
		if input.match?(/\d+-\d+/)
			levels = input.split("-").map(&:to_i)
			output = calculate_cp_from_level_to_level(levels[0], levels[1])
		elsif input.match?(/\d+/)
			output = calculate_cp_from_level_to_level(0, input.to_i)
		end
		event << output 
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop; remove_command(:cpToLvl); end


end; # FallenLondon
end; end # Plugins; SurfBot
