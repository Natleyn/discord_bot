require './surfBotInfo.rb'
require 'discordrb'

# Keep name lowercase for matching purposes
surfCmdPrefix = ';'
surfName = 'Lagoon'

maxDiscordMsgChars = 2000

# Data Structores
raceHash = {
	# clientID => race string,
	134913027613917184 => "pony",
	237410355486261266 => "lizard",
}

fortuneResponses = [
	[
		"Yes.",
		"Yes! Yes!",
		"Indubitably.",
		"#{surfName} thinks so.",
		"Yes, if it makes pony stop asking.",
		"The rocks agree, and so it shall be!",
		"My gems point towards yes!",
		"Make it so."
	],
	[
		"No.",
		"No! Do not!",
		"Doesn't seem like it.",
		"No, if it makes pony stop asking.",
		"I think not.",
		"The rocks disagree.",
		"My gems point towards no.",
		"No, pony."
	]
]

cards = [
	[
		"Two",
		"Three",
		"Four",
		"Five",
		"Six",
		"Seven",
		"Eight",
		"Nine",
		"Ten",
		"Jack",
		"Queen",
		"King",
		"Ace"
	],
	[
		"Clubs",
		"Diamonds",
		"Hearts",
		"Spades"
	]
]

randomResponses = [
	"Try `%s`.",
	"How about `%s`?",
	"`%s`, maybe.",
	"Pony should `%s`.",
	"I think `%s` would make pony happy.",
	"My gems point towards `%s`.",
	"Uhh... #{surfName} doesn't know. `%s`?",
	"I had a dream where gems surrounded `%s`.",
	"`%s` sounds good."
]

bot = Discordrb::Commands::CommandBot.new token: $surf_client_token, client_id: $surf_client_token, prefix: surfCmdPrefix

exit_bool = false

# Admin commands
bot.command(:swapname, max_args: 1, help_available: false) do |event|
	break unless event.user.id == $sea_client_id 
	msg = event.message.to_s.slice((surfCmdPrefix.length+9)..-1)
	msg.strip! if !msg.nil?
	bot.profile.name = (msg.nil?) ? surfName.capitalize : msg.strip
	event.respond "Swapping to #{bot.profile.name}, my good pony."
end
bot.command(:inviteurl, help_available: false) do |event|
	break unless event.user.id == $sea_client_id
	event.respond "https://discordapp.com/api/oauth2/authorize?client_id=#{$surf_client_id}&scope=bot&permissions=0"
end

#Read in all files from within the plugins folder.

#require_relative './plugins/randomItem.rb'

bot.command(:draw, description: "Draw a card.") do |event, *args|
	#bot.send_message("185914979050848256","Arg: " + args[0].to_s)
	if !args[0].to_s.strip.nil? && args[0] =~ /[0-9]/
		num = Integer(args[0])
		if num <= 10 
			numCards = num
		elsif num > 10
			event.respond "Too many cards! Try less than ten."
			break
		end
	else
		numCards = 1
	end
	cardString = ""
	numCards.times do
		roll = rand(1..54)
		case roll
		when 1..52
			card = cards[0].sample + " of " + cards[1].sample
		when 53
			card = "Joker (with tm)"
		when 54
			card = "Joker (without TM)"
		end 
		cardString += card + "\n"
	end
	cardString.strip!
	cardString = "\n" + cardString if numCards > 1
	event.respond "You drew: " + cardString
end

def regularRoll(max)
	return rand(1..max)
end

def weightedRoll(max)
	return 1
end


@defaultDie = "1d20"
def rollDice(msg, toWeight)
	# Sanitization	
	# msg = event.message.to_s.split // Legacy code
	if msg[1].nil? || !(msg[1] =~ /\A.*\d.*\z/)
		rollData = @defaultDie
	else	
		rollData = msg[1].strip
	end
	# Testing sanitization
	rollData.sub!(/\A\++(.*)\z/, '\1')
	rollData.gsub!(/[^dx\d\+-]/, '')
	rollData.gsub!(/([+-])[+-]*/, '\1')
	rollData.gsub!(/(d)d*/, '\1')
	rollData.gsub!(/(x)x*/, '\1')
	# Reject string if it doesn't fit format
	unless rollData =~ /\A(([0-9]+d[0-9]+)|(-?[0-9]+))([-+](([0-9]+d[0-9]+)|([0-9]+)))*(x[0-9]+)?\z/
		# event.respond "Improper dice format: #{rollData}"
		return "Improper dice format: #{rollData}"
	end

	multiplier = 1
	# if multiplier exists, chop it off and save the number
	if rollData =~ /\A.*x.*\z/
		multiplier = Integer(rollData.split('x')[1])
		rollData = rollData.sub(/\A(.*)x[0-9]+\z/, '\1')
		if multiplier > 10
			# event.respond "Error: Multiplier too high."
			return "Error: Multiplier too high."
		end
	end

	signs = (rollData =~ /\A-.*\z/)? ["-"] : ["+"]
	# Split the message into one of two types, split on -+
	if rollData =~ /\A.*[-+].*\z/
		diceInfo = rollData.split(/[-+]/)
		signs += rollData.scan(/[-+]/)
	else
		diceInfo = [rollData]
	end
	finalString = ""
	multiplier.times do |repetition|
		totalNumDice = 0
		diceSum = 0
		numberSum = 0
		diceText = ""
		numberText = ""
		index = 0
		diceInfo.each do |roll|
			sign = signs[index]
			# Handle each case separately 
			if roll =~ /\A[0-9]+d[0-9]+\z/
				diceNums = roll.split('d')
				numDice = Integer(diceNums[0])
				numSides = Integer(diceNums[1])
				if ( !numDice.between?(1,100) || !numSides.between?(1,100) )
					# event.respond "Number of dice or number of sides incorrect."
					return "Number of dice or number of sides incorrect."
				else
					numDice.times {
						if totalNumDice > 150
							#event.respond "Too many dice."
							return "Too many dice."
						end
						totalNumDice += 1
						if toWeight
							curNum = weightedRoll(numSides)
						else
							curNum = regularRoll(numSides)
						end
						if sign == "-"
							diceSum -= curNum
						else
							diceSum += curNum
						end
						diceText << sign unless diceText.length == 0
						diceText << curNum.to_s
					}
				end
			elsif roll =~ /\A[0-9]+\z/
				if sign == "-"
					numberSum -= Integer(roll)
				else
					numberSum += Integer(roll)
				end
				numberText << sign unless numberText.length == 0 && sign != "-"
				numberText << roll.to_s
			end
			index += 1
		end
		# Print out results
		rollString = rollData + " = "
		if totalNumDice <= 6
			if totalNumDice > 1
				rollString += "[" + diceText + "]"
				rollString += " + " + numberText if numberSum != 0
				rollString += " = "
			elsif totalNumDice == 1
				rollString += "[" + diceText + "] + " + numberText + " = " if numberSum != 0
			end
		elsif numberSum != 0
			rollString += diceSum.to_s + " + " + numberText + " = "
		end
		rollString += (multiplier > 1) ? (diceSum + numberSum).to_s : "**" + (diceSum + numberSum).to_s + "**"
		rollString += "\n" if repetition != (multiplier-1)
		finalString += rollString
	end
	finalString = "```" + finalString + "```" if multiplier > 1
	# event.respond finalString
	return finalString
end

# Roll - rolls a number of dice.
bot.command(:roll, description: 'Rolls a number of dice (max 100d100, and up to 150 total dice).', usage: surfCmdPrefix + 'roll <number of dice>d<number of sides on die>; i.e. \'' + surfCmdPrefix + 'roll 1d20\'') do |event|
	event.respond rollDice(event.message.to_s.split, false)
end

bot.command(:wroll, description: 'Rolls dice, but with a specific weighting algorithm that decreases the likelihood of the same number being chosen after it is rolled.', usage: surfCmdPrefix + 'roll <number of dice>d<number of sides on die> [+/- (modifier or additional dice)]') do |event|
	event.respond rollDice(event.message.to_s.split, true)
end

def pickRandomOption(listString)
	options = listString.gsub(/or/, ',').gsub(/,\s*,+/,',').gsub(/\?/,'')
	choice = options.split(',').sample
	puts options
	return choice.strip
end

# Random - picks at random from a list of provided strings.
bot.command(:random, min_args: 1, description: 'Picks an item from a provided list.', usage: surfCmdPrefix + 'random item1[, item2, item3...]') do |event|
	break if event.user.current_bot?

	msg = event.message.content
	options = msg.slice((surfCmdPrefix.length+7)..-1)
	event.respond randomResponses.sample % [pickRandomOption(options)]
end

# Quit command
bot.command(:exit, help_available: false) do |event|
	break unless event.user.id == $sea_client_id 
	event.respond "Shutting down."
	bot.stop
	exit_bool = true
end

bot.command(:test, help_available: false) do |event|
	event.respond "test" % ["test"]
end

bot.command(:embedtest, help_available: false) do |event|
	break unless event.user.id == $sea_client_id

	embed = Discordrb::Webhooks::Embed.new(
		author: { name: "Sea" }
	)
	#embed.initialize
	embed.add_field(name: '',value: "test",inline: true)
	#embedText = Discordrb::Webhooks::EmbedField.new
	#embedText.initialize(nil,"test",true)
	#embed << embedText
	#bot.send_message(event.channel.id, "", false, embed)
	event.channel.send_embed('', embed)
end

# Generic commands
bot.command(:invite_url, help_available: false) do |event|
	break unless event.user.id == $sea_client_id
	event.bot.invite_url
end
bot.command(:boop, help_available: false) do |event|
	event.respond "[scrunch]"
end
bot.command(:pet, help_available: false) do |event|
	event.respond "[happy doggo noises]"
end
bot.command(:patpat, help_available: false) do |event|
	event.respond "[happy doggo noises]"
end
bot.command(:brushie, help_available: false) do |event|
	event.respond "[happy doggo noises]"
end
bot.command(:feed, help_available: false) do |event|
	event.respond "[happy munching doggo noises]"
end
bot.command(:biscuit, help_available: false) do |event|
	event.respond "[happy munching doggo noises]"
end
bot.command(:treat, help_available: false) do |event|
	event.respond "[happy munching doggo noises]"
end
bot.command(:newspaper, help_available: false) do |event|
	event.respond ["Pony knows not what they do.", "Do not!", "_:newspaper2: @ u_"].sample
end
bot.command(:spritz, help_available: false) do |event|
	event.respond "[unhappy doggo noises]"
end

# Logging messages to console
bot.message do |event|
	unless event.channel.type == 1
		serverName = event.channel.server.name
		channelName = "#" + event.channel.name
	else
		serverName = "PM"
		channelName = "@" + event.user.username
	end
	userName = event.user.username
	theMessage = event.message
	puts "<#{serverName}.#{channelName}> #{userName}: #{theMessage}"
end

# Fortune command
bot.message do |event|
	msg = event.message.to_s.chomp
	respondWithFortune = (msg =~ /(#{surfName},.*\?)|(#{surfName}\?$)/i)
	respondWithRandom = (msg =~ /#{surfName},.*or.*\?/i)
	if respondWithRandom
		options = msg.slice((surfName.length+1)..-1)
		event.respond randomResponses.sample % [pickRandomOption(options)]
	elsif respondWithFortune 
		event.respond fortuneResponses.sample.sample
	end
end

bot.message(with_text: 'Ping!') do |event|
	event.respond 'Pong!'
end

bot.message(with_text: "Sleep well, #{surfName}") do |event|
	break unless event.user.id == $sea_client_id 
	event.respond "You too, pony."
	bot.stop
	exit_bool = true
end

=begin this doesn't work; bot isn't defined for the method
def stopBot(event)
	event.respond "You too, pony."
	bot.stop
	exit_bool = true
end
=end

# This doesn't work; it waits for the message before starting the bot
#msg = gets.chomp
#bot.send_message(185914979050848256, msg, false, nil)

bot.run


=begin this doesn't work; these aren't executed (?) until the bot stops
while !exit_bool
	totalcmd = gets.chomp
	#DEBUG
	puts "Command: #{totalcmd}"
	cmd = totalcmd.slice!(/^\S+\s+/).strip unless totalcmd.to_s.strip.empty?
	case cmd
		when "say"
			puts "Command '#{cmd}' recognized."
			channelID = totalcmd.slice!(/^\S+\s+/)
			bot.send_message(channelID, totalcmd, false, nil)
		when "act"
			puts "Command '#{cmd}'recognized."
			channelID = totalcmd.slice!(/^\S+\s+/)
			bot.send_message(channelID, "_#{totalcmd}_", false, nil)
		else
			puts "Command not recognized: #{cmd} #{totalcmd}"
	end
end
=end
