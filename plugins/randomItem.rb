require 'discordrb'

def random(bot)
	bot.command(:random, min_args: 1, description: 'Picks an item from a provided list.', usage: surfCmdPrefix + 'random item1[, item2, item3...]') do |event|
		break if event.user.current_bot?

		msg = event.message.content
		options = msg.slice(9..-1).split(',')
		choice = options.sample
		choice.strip! unless choice.nil?
		event.respond randomResponses.sample % [choice]
		#event.split(',').sample
	end
end
