require './surfBotInfo.rb'
require 'discordrb'



bot = Discordrb::Commands::CommandBot.new token: $surf_client_token, client_id: $surf_client_token, prefix: '::'

bot.message do |event|
	puts "<#{event.channel.server.name}.#{event.channel.name}> #{event.user.username}: #{event.message}"
end

bot.message(with_text: 'Ping!') do |event|
	event.respond 'Pong!'
end

bot.message(with_text: 'Sleep well, Surf.') do |event|
	if event.user.id == 134913027613917184
		bot.stop
	end
end

bot.run
