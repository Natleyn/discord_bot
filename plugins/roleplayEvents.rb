# roleplayEvents.rb
# Author: natleyn
# Version: 1.0.0
# The event plugin for handling roleplay interactions with chat.

require_relative '../surfInfo'

module SurfBot; module Plugins
module Roleplay
	extend Discordrb::EventContainer
	def self.filename; "roleplayEvents.rb"; end
	
	@@BRUSHIE_CHANCE = 25

	message(contains: /.*\b(weh|<:weh:283350939681947648>|<:misty:405192023499472906>)\b.*/i ) do |event|
		if SurfBot.roleplay_servers.include? event.server.id
			event.message.react ":brushie:404557439925747742" if (rand(1..100) < @@BRUSHIE_CHANCE)
		end
	end


end # Roleplay
end; end # Plugins; SurfBot
