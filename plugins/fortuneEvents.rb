# fortuneEvents.rb
# Author: natleyn
# Version: 1.0.0
# The event plugin for handling fortune/random messages that don't come through commands. 

require_relative '../data/fortune'
require_relative '../surfBotInfo2'

module SurfBot; module Plugins
module Fortune
	extend Discordrb::EventContainer
	def self.filename; "fortuneEvents.rb"; end

	message do |event|
		msg = event.message.to_s.chomp
		do_fortune = (msg =~ /(^#{SurfBot.surf_name},.*\?$)|(^.*#{SurfBot.surf_name}\?$)/i)
		do_random = (msg =~ /^#{SurfBot.surf_name},.*\Wor\W.*\?$/i)
		if do_random
			options = msg.slice((SurfBot.surf_name.length+1)..-1)
			event.respond @@random_responses.sample % [pick_random_option(options)]
		elsif do_fortune 
			event.respond @@fortune_responses.sample.sample
		end	
	end

	# No instance variables to clean up- can't stop event handlers either
	# TODO: Look into Discordrb::Await as an alternative
	def self.clean_up; end
	def self.stop; end

end # Fortune
end; end # Plugins; SurfBot
