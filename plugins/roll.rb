# roll.rb
# Author: natleyn
# Version: 3.0.0
# Allows you to roll dice, or to roll on D&D5e's official Wild Magic Surge table (WMS), or on a homebrew Wild Magic Surge table (WMS2). D&D5e centric.
# Changelog:
# 3.0.0
#  - Wrote an entirely new roll function, utilizing various smaller functions created with acceptance and integration testing in mind
#  - Moved a bit of functionality around in doing so- 3.0.0 is incompatible with <2.2.1 due to the major function changes
#  - Output for the end user has NOT changed, but is easier to modify and test for future changes
# 2.2.1
#  - Fixed a lot of faulty code (dropping dice on a roll that included other dice, roll_data being able to modify @@default_die, etc).
#  - In addition, added dropping highest dice instead of lowest via -D<z> on a dice roll, and the ability to modify the default die by adding adv/dis
#      after the roll text.
#  - Moved argument handling from the command function to the rolling one, to reduce the amount of arguments being passed through. 
# 2.1.0
#  - Added 'dropped dice'- you can now add -d<z> to a dice roll to drop the lowest z dice from that roll.
# 2.0.0
#  - Changed how the results display to the user, separating individual 'stacks' of dice and numbers for a more easily correlatable solution.
#  - Added background support for dropping dice, but didn't implement it.
# 1.0.1
#  - Fixed an error in default die application ([-+] was not what I thought it was and didn't include x; moved to [x\-+])

require_relative '../surfBotInfo2'
require_relative '../data/wmsInfo'
require_relative '../data/wms2Info'
require_relative '../data/extraFunctions.rb'

module SurfBot; module Plugins
module Roll
	extend Discordrb::Commands::CommandContainer
	def self.filename; "roll.rb"; end

	@@default_die = "1d20"

	# Constant boundaries
	@@MAX_DICE = 200
	@@MAX_SIDES = 100
	@@MAX_INPUT_LENGTH = 150 # in chars
	# How many numbers should be shown before you need to use full to see rolls
	@@FULL_THRESHOLD = 10

	def self.standard_roll(max); return rand(1..max); end
	def self.weighted_roll(max); return 1; end

	# adds the default die to the start of the roll string under certain circumstances:
	# 1) string starts with a + or -
	# 2) no roll provided
	# Also applies advantage or disadvantage to the default die, should the argument be provided.
	def self.apply_default_die(input, adv, dis)
		roll = input
		if !roll.match?(/\A.*\d.*\z/)
			roll = "#{@@default_die}"
		elsif input.match?(/\A[-+x].*/)
			roll = "#{@@default_die}#{roll}"
		end

		if adv
			roll.sub!("#{@@default_die}", "2d20d1")
		elsif dis
			roll.sub!("#{@@default_die}", "2d20D1")
		end
		roll
	end

	# Removes any characters that aren't used for input.
	def self.sanitize_roll(input)
		roll_data = input.dup
		roll_data.gsub!(/[^dDx\d+-]/, '') # remove anything not d,D,x,digit 0-9,+,-
		roll_data.gsub!(/([-+])[-+]*/, '\1') # remove consecutive +/-'s
		roll_data.gsub!(/(d)d+/, '\1') # remove consecutive d's
		roll_data.gsub!(/(D)D+/, '\1') # remove consecutive D's
		roll_data.gsub!(/(x)x+/, '\1') # remove consecutive x's
		roll_data
	end

	# Executed in four parts:
	#  - remove multiplier
	#  - split on [+-], record rolls and signs
	#  - split on [Dd], record numbers and roll symbols
	#  - store numbers, symbols, signs, and the multiplier in data, in that order, and return data
	def self.parse_roll(input)
		data = []
		roll_text = input.split('x')
		rolls = roll_text[0].to_s
		multiplier = (roll_text[1].to_s.empty?)? "1" : roll_text[1].to_s
		roll_nums = []
		roll_symbols = []
		signs = ["+"] + rolls.scan(/[+-]/)
		rolls.split(/[+-]/).each do |r|
			roll_nums << ((r.match?(/.*d.*/))? r.split(/[Dd]/) : r)
			roll_symbols << r.scan(/[Dd]/)
		end
		data << roll_nums << roll_symbols << signs << multiplier
	end

	# Adds up an array that contains any mix of integers and arrays of integers.
	def self.sum_roll_array(array, signs)
		sum = 0
		array.each_with_index do |e, i|
			temp_e = (e.respond_to?(:sum)? e.sum : e )
			sum += ((signs[i] == "-")? -temp_e : temp_e)
		end
		sum
	end


	# Takes in the parsed data array and uses it to roll dice.
	# Outputs an array of:
	#	0 rolled numbers and constants in order,
	#	1 the sum of above,
	#	2 the same rolls but with the dice dropped,
	#	3 the sum of above (without the dice that were dropped),
	#	4 the sum of all constants (for simplifying later calculations, namely dice sum)
	#	5 the number of numbers (dice and constants) in this roll, for deciding whether or not to shorten it.
	def self.calculate_roll(numbers, roll_symbols, signs, weight)
		data = []
		nums = []
		dnums = [] # dropped number array
		# these two used later in stringify_short if too many numbers to display
		constants = [] 
		const_signs = []
		num_of_nums = 0
		numbers.each_with_index do |roll, index|
			if roll.is_a? Array
				rolls = []
				num_dice = Integer(roll[0])
				num_sides = Integer(roll[1])
				num_dice.times do
					rolls << ((weight)? weighted_roll(num_sides) : standard_roll(num_sides))
				end
				num_of_nums += num_dice

				nums << rolls
				case roll_symbols[index][1]
				when "d"
					dnums << remove_lowest(rolls, Integer(roll[2]))
				when "D"
					dnums << remove_highest(rolls, Integer(roll[2]))
				else
					dnums << rolls
				end
			else # its a number
				nums << Integer(roll)
				dnums << Integer(roll)
				constants << Integer(roll)
				const_signs << signs[index]
				num_of_nums += 1
			end
		end
		normal_sum = sum_roll_array(nums, signs)
		dropped_sum = sum_roll_array(dnums, signs)
		constant_sum = sum_roll_array(constants, const_signs)
		data << nums << normal_sum << dnums << dropped_sum << constant_sum << num_of_nums
	end

	# Formats a roll array (array of ints and arrays of ints) for output.
	def self.stringify_roll(numbers, signs)
		output = ""
		numbers.each_with_index do |roll, index|
			output << "#{roll.to_s.gsub(", ", '+').gsub("\"", '')}"
			output << " #{signs[index+1]} " unless signs[index+1].nil?
		end
		output
	end

	# Formats a roll array to print out sums instead of a formatted array of numbers.
	def self.stringify_short(numbers)
		#puts "#{numbers}" # DEBUG
		"[#{((numbers[1] != numbers[3])? numbers[3] : numbers[1])-numbers[4]}] + #{numbers[4]}"
	end

	# Compile the final output string from its parts.
	def self.form_result(input_text, roll_data, signs, display_full, num_rolls)
		output = "#{input_text}"
		#puts "form roll_data #{roll_data}" # DEBUG
		result = "#{roll_data[1]}"
		# only print out the sum if there's one die being rolled
		if (roll_data[0].length > 1 || roll_data[0][0].length > 1)
			output << " = #{((display_full || (num_rolls <= @@FULL_THRESHOLD))? stringify_roll(roll_data[0], signs) : stringify_short(roll_data))}"
		end

		# if the normal sum and dropped sum are the same, the numbers are the same
		# if not, there was a dropped roll
		if (roll_data[1] != roll_data[3])
			output << " => #{stringify_roll(roll_data[2],signs)}"
			result = "#{roll_data[3]}"
		end
		output << " = **#{result}**"
	end

	# roll_dice 2.0: split various functionality into other functions for both testing and simplicity purposes.
	def self.roll_dice(input, weight_rolls, args)
		#puts "input #{input}" # DEBUG
		# Check args for various keywords for use in options later
		full_roll_text = args.any? { |arg| arg.match? /full/i }
		advantage = args.any? { |arg| arg.match? /adv(antage)?/i }
		disadvantage = args.any? { |arg| arg.match? /dis(advantage)?/i }
		average = args.any? { |arg| arg.match? /(avg|average)/i }
		
		dd_input = apply_default_die(input, advantage, disadvantage)
		#puts "default_die #{dd_input}" # DEBUG

		sanitized_input = sanitize_roll(dd_input)
		#puts "sanitized #{sanitized_input}" # DEBUG
		return "Error in input: Improper dice format (#{sanitized_input})" unless sanitized_input.match?(/\A([-+]?((\d+d\d+([Dd]\d+)?)|(\d+)))*(x\d+)?\z/)
		return "Error in input: Input too long (Max #{@@MAX_INPUT_LENGTH} chars)" if sanitized_input.length > @@MAX_INPUT_LENGTH

		parsed_input = parse_roll(sanitized_input)
		#puts "parsed #{parsed_input}" # DEBUG
		# test for #dice #sides
		return "Error in input: Dropping too many dice." if (parsed_input[0].any? do |e|; Integer(e[2]) >= Integer(e[0]) if (e.respond_to?(:at) && !e.at(2).nil?); end)
		return "Error in input: Too many dice. (Max #{@@MAX_DICE})" if (parsed_input[0].sum do |e|; ((e.respond_to?(:at))? Integer(e.at(0)) : 1); end) > @@MAX_DICE
		return "Error in input: Too many sides on a die. (Max d#{@@MAX_SIDES})" if (parsed_input[0].any? do |e|; Integer(e[1]) > @@MAX_SIDES if e.respond_to?(:at); end)

		multiplier = Integer(parsed_input.pop)
		final_string = ""
		multiplier.times do |repetition|
			calculated_rolls = calculate_roll(parsed_input[0], parsed_input[1], parsed_input[2], weight_rolls)
			#puts "calculated #{calculated_rolls}" # DEBUG
			final_string << "#{form_result(dd_input.split("x")[0], calculated_rolls, parsed_input[2], full_roll_text, calculated_rolls[5])}\n"
		end
		if multiplier > 1
			"```#{final_string.gsub(/\*/, '')}```"
		else
			final_string
		end
	end

	command(:reseed,
		description: "Reseed the random number generator."
			) do |event|
		#break unless event.user.id == SurfBot.sea_client_id
		Random.srand
		event << "RNG reseeded."
	end

	command(:roll,
		description: 'Rolls a number of dice (max 100d100, and up to 150 total dice).',
		usage: "#{SurfBot.surf_cmd_prefix}roll <number of dice>d<number of sides on die>; i.e. #{SurfBot.surf_cmd_prefix}roll 1d20"
			) do |event, *args|
		input = "#{args[0]}"
		# Wild Magic Surge; might wanna put this elsewhere because it won't show up on help.
		if input.match? /^wms$/i
			output = WMS::roll_WMS()
		elsif input.match? /^wms2$/i
			output = WMS2::roll_WMS()
		else
			output = roll_dice(input, false, args)
		end
		event << output
	end
	command(:wroll,
		description: 'Rolls dice, but with a specific weighting algorithm that decreases the likelihood of the same number being chosen after it is rolled.', 
		usage: "#{SurfBot.surf_cmd_prefix}roll <number of dice>d<number of sides on die> [+/- (modifier or additional dice)]"
			) do |event, *args|
		input = "#{args[0]}"
		event << roll_dice_a(input, true, args[0..2])
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop
		remove_command(:reseed)
		remove_command(:roll)
		remove_command(:wroll)
	end

end # Roll
end; end # Plugins; SurfBot
