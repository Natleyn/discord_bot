# roll.rb
# Author: natleyn
# Version: 1.0.1
# Allows you to roll dice, or to roll on D&D5e's official Wild Magic Surge table (WMS), or on a homebrew Wild Magic Surge table (WMS2)
# Changelog:
# 1.0.1
#  - Fixed an error in default die application ([-+] was not what I thought it was and didn't include x; moved to [x\-+])

require_relative '../surfBotInfo2'
require_relative '../data/wmsInfo'
require_relative '../data/wms2Info'

module SurfBot; module Plugins
module Roll
	extend Discordrb::Commands::CommandContainer
	def self.filename; "roll.rb"; end

	@@default_die = "1d20"

	def self.regular_roll(max); return rand(1..max); end
	def self.weighted_roll(max); return 1; end

	def self.roll_dice(input, weight_rolls, full_roll_text)
		# Wild Magic Surge; might wanna put this elsewhere because it won't show up on help.
		if(input =~ /^wms$/i) ; return WMS::roll_WMS() ; end
		if(input =~ /^wms2$/i) ; return WMS2::roll_WMS() ; end
		# Check if the first argument is empty (refer to default die), starts with +/-/x (apply to default die), or
		# 
		if input.nil? || !(input =~ /\A.*\d.*\z/)
			roll_data = @@default_die
		elsif input =~ /\A[x\-+].*\z/
			roll_data = "#{@@default_die}#{input.strip}"
		else	
			roll_data = input.strip
		end
		# Sanitization
		roll_data.gsub!(/[^dx\d\+-]/, '') # remove anything not d,x,digit 0-9,+,-
		roll_data.gsub!(/([+-])[+-]*/, '\1') # remove consecutive +/-'s
		roll_data.gsub!(/(d)d*/, '\1') # remove consecutive d's
		roll_data.gsub!(/(x)x*/, '\1') # remove consecutive x's
		# Reject string if it still doesn't fit format
		unless roll_data =~ /\A(([0-9]+d[0-9]+)|(-?[0-9]+))([-+](([0-9]+d[0-9]+)|([0-9]+)))*(x[0-9]+)?\z/
			return "Improper dice format: #{roll_data}"
		end
	
		# if multiplier exists, chop it off and save the number; otherwise it's 1
		if roll_data =~ /\A.*x.*\z/
			multiplier = Integer(roll_data.split('x')[1])
			roll_data.sub!(/\A(.*)x[0-9]+\z/, '\1')
			if multiplier > 10
				return "Error: Multiplier too high."
			end
		else
			multiplier = 1
		end
	
		signs = (roll_data =~ /\A-.*\z/)? ["-"] : ["+"]
		# Split the message into sets; if there's +/-, create a signs array to keep the +'s and -'s removed by split
		# Otherwise, just put the roll into an array so further parsing works
		if roll_data =~ /\A.*[-+].*\z/
			dice_info = roll_data.split(/[-+]/)
			signs += roll_data.scan(/[-+]/)
		else
			dice_info = [roll_data]
		end
		final_string = ""
		multiplier.times do |repetition|
			total_num_dice = 0
			dice_sum = 0
			number_sum = 0
			dice_text = ""
			number_text = ""
			index = 0
			dice_info.each do |roll|
				sign = signs[index]
				# Handle each case separately 
				if roll =~ /\A[0-9]+d[0-9]+\z/
					diceNums = roll.split('d')
					num_dice = Integer(diceNums[0])
					num_sides = Integer(diceNums[1])
					if ( !num_dice.between?(1,100) || !num_sides.between?(1,100) )
						return "Number of dice or number of sides incorrect."
					else
						num_dice.times {
							if total_num_dice > 200
								return "Too many dice."
							end
							total_num_dice += 1
							cur_num = (weight_rolls)? weighted_roll(num_sides) : regular_roll(num_sides)
							dice_sum += (sign == "-")? -cur_num : cur_num
							dice_text << sign unless dice_text.length == 0
							dice_text << cur_num.to_s
						}
					end
				elsif roll =~ /\A[0-9]+\z/
					number_sum += ((sign == "-")? Integer("-#{roll}") : Integer(roll))
					number_text << sign unless number_text.length == 0 && sign != "-"
					number_text << roll.to_s
				end
				index += 1
			end
			# Print out results
			roll_string = "#{roll_data}"
			backup_string = "#{roll_data}"
			nums_exist = !number_text.to_s.strip.empty?
			total_nums = total_num_dice + ((nums_exist)?1:0)
			if total_nums > 1
				# Add dice to results string
				roll_string += " = "
				backup_string += " = [#{dice_sum}]"
				if total_num_dice <= 6 || (full_roll_text && !(multiplier>1))
					roll_string += "[#{dice_text}]"
				else
					roll_string += "[#{dice_sum}]"
				end
				# Add numbers to results string
				backup_string += (!nums_exist)? "" : " + #{number_sum}"
				if number_sum != 0 && number_text.length < 30
					roll_string += " + #{number_text}"
				elsif !nums_exist
					roll_string += " + #{number_sum}"
				end
			end
			# Add sum to results string
			roll_string += " = "
			backup_string += " = **#{dice_sum + number_sum}** (Too many numbers to display)"
			roll_string += (multiplier > 1) ? (dice_sum + number_sum).to_s : "**" + (dice_sum + number_sum).to_s + "**"
			roll_string += "\n" if repetition != (multiplier-1)
			roll_string = (!(multiplier > 1) && roll_string.length > SurfBot.max_discord_msg_chars ? backup_string : roll_string )
			final_string += roll_string
		end
		final_string = "```" + final_string + "```" if multiplier > 1
		return final_string
	end

	command(:reseed,
		description: "Reseed the random number generator."
			) do |event|
		break unless event.user.id == SurfBot.sea_client_id
		Random.srand
		event << "RNG reseeded."
	end

	command(:roll,
		description: 'Rolls a number of dice (max 100d100, and up to 150 total dice).',
		usage: "#{SurfBot.surf_cmd_prefix}roll <number of dice>d<number of sides on die>; i.e. #{SurfBot.surf_cmd_prefix}roll 1d20"
			) do |event|
		input = event.message.to_s.split[1]
		full_roll_text = event.message.to_s.split.any? { |arg| arg =~ /full/i }
		event << roll_dice(input, false, full_roll_text)
	end
	command(:wroll,
		description: 'Rolls dice, but with a specific weighting algorithm that decreases the likelihood of the same number being chosen after it is rolled.', 
		usage: "#{SurfBot.surf_cmd_prefix}roll <number of dice>d<number of sides on die> [+/- (modifier or additional dice)]"
			) do |event|
		input = event.message.to_s.split[1]
		full_roll_text = event.message.to_s.split.any? { |arg| arg =~ /full/i }
		event << roll_dice(input, true, full_roll_text)
	end

	def self.clean_up; end
	def self.stop
		remove_command(:reseed)
		remove_command(:roll)
		remove_command(:wroll)
	end

end # Roll
end; end # Plugins; SurfBot
