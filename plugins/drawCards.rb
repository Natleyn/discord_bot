# drawCards.rb
# Author: natleyn
# Version: 1.0.0
# Lets you draw cards, either from a 54 card deck (jokers included) or a homebrew D&D5e Deck of Many Things (DoMT)

require_relative '../surfBotInfo2'
require_relative '../data/domtCards'

module SurfBot; module Plugins
module DrawCards
	extend Discordrb::Commands::CommandContainer
	def self.filename; "drawCards.rb"; end

	@@cards = [
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

	def self.draw_card(num_cards, domt)
		
	end

	# TODO: put this stuff into draw_card
	command(:draw,
		description: "Draw up to 10 cards from a standard 54 card deck, or up to four cards from the D&D5e DoMT (Deck of Many Things).",
		) do |event, *args|
		# Figure out if we're using the DoMT
		domt_present = false
		domt_present = true if args[0] =~ /domt/i || args[1] =~ /domt/i
		domt_is_2 = false
		domt_is_2 = true if args[1] =~ /domt/i
		if domt_present && !domt_is_2
			num_cards_string = args[1]
		else
			num_cards_string = args[0]
		end

		if !num_cards_string.to_s.strip.nil? && num_cards_string =~ /^[0-9]+$/
			num = Integer(num_cards_string)
			if domt_present && num > 4
				event.respond "Too many DoMT cards! I can't display all that text."
				return
			elsif num > 0 && num <= 10
				num_cards = num
			elsif num > 10
				event.respond "Too many cards! Try less than ten."
				return
			elsif num <= 0
				event.respond "Too few cards; you need at least one."
				return
			end
		else
			num_cards = 1
		end
		card_string = ""
		num_cards.times do
			roll = rand(1..54)
			case roll
			when 1..52
				card = @@cards[0][roll%13] + " of " + @@cards[1][(roll-1)/13]
			when 53
				card = "Joker:tm:"
			when 54
				card = "Joker"
			end 
			card_string += card
			if domt_present
				domt_text = DoMT::draw_card(card)
				card_string += " - #{domt_text}"
			end
			card_string += "\n"
		end
		card_string.strip!
		card_string = "\n" + card_string if num_cards > 1
		if ("You drew: " + card_string).length > SurfBot.max_discord_msg_chars
			event.respond "Too many cards, too much text. Sorry."
			break
		end
		event.respond "You drew: #{card_string}"
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop; remove_command(:draw); end

end # DrawCards
end; end # Plugins; SurfBot
