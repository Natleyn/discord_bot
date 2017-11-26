# getIP.rb
# Author: natleyn
# Version: 1.0.0
# Simple tool to allow me to get my server's public IP remotely using ipify.org's service API.

require 'net/http'
require_relative '../surfBotInfo2'

module SurfBot; module Plugins
module GetIP
	extend Discordrb::Commands::CommandContainer
	def self.filename; "getIP.rb"; end

	def self.get_ip; "My IP: #{Net::HTTP.get(URI("https://api.ipify.org/"))}"; end

	command(:get_public_ip,
		description: "Get SurfBot's server's public IP.",
		help_available: false
		) do |event|
		return unless event.user.id == SurfBot.sea_client_id
		event << get_ip
	end


	def self.clean_up; end
	def self.stop; remove_command(:get_public_ip); end
	
end # GetIP
end; end # Plugins; SurfBot
