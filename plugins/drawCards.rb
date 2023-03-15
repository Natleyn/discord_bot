# drawCards.rb
# Author: natleyn
# Version: 1.1.0
# Lets you draw cards, either from a 54 card deck (jokers included) or a homebrew D&D5e Deck of Many Things (DoMT)
# 1.1.0
#  - Moved functionality from the command handler to a separate function to facilitate testing and reloadability.
#  - Refactored existing code to conform to current style patterns.

require_relative '../surfInfo'
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

	def self.draw_cards(num_cards, domt)
		# Limit the number of cards by format.
		return "You can't draw that many cards, silly." if (num_cards <= 0)
		return "Too many cards! Try ten or less." if (num_cards > 10)
		return "Too many DoMT cards. Try less than five." if (domt && num_cards > 5)
		# Build the string to return
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
			card_string << card
			card_string << " - #{DoMT::draw_card(card)}" if domt
			card_string += "\n"
		end
		#puts "#c #{num_cards}; domt? #{domt}"
		card_string = "You drew: #{(num_cards > 1 ? "\n" : "") + card_string.strip!}"
		return "Too many cards, too much text." if card_string.length > SurfBot.max_discord_msg_chars
		card_string
	end

	command(:draw,
		description: "Draw up to 10 cards from a standard 54 card deck, or up to four cards from the D&D5e DoMT (Deck of Many Things).",
		) do |event, *args|
		# Get number of cards being drawn
		num_cards = ( args.any? { |e| e.match?(/\b\d+\b/) } ? args.find { |e| e.match?(/\b\d+\b/i) }.to_i : 1 )
		# Figure out if we're using the DoMT
		domt_present = args.any? { |e| e.match?(/domt\b/i) }
		event << draw_cards(num_cards, domt_present)
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop; remove_command(:draw); end

end # DrawCards
end; end # Plugins; SurfBot
