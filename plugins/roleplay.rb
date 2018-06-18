# roleplay.rb
# Author: natleyn
# Version: 1.0.1
# Holds commands that are mainly used to interact with the bot like a (somewhat) sentient entity.
# Changelog:
# 1.0.1
#  - Added random weighted element command (might just put that in the kernel) and made scrunches
#    work on a weighted array

require_relative '../data/extraFunctions'

module SurfBot; module Plugins
module Roleplay
	extend Discordrb::Commands::CommandContainer
	def self.filename; "roleplay.rb"; end

	@@hugs_list = [
		"_hugs %s back_", 
		"_picks %s up and hugs them firmly_",
		"_hug of %s_",
		"_gives %s a big ol' ~~bear~~ doggo hug_"
	]
	@@newspaper_list = [
		"Pony knows not what they do.",
		"Do not!",
		"_:newspaper2: @ u_"
	]
	@@scrunch_list = {
		"[scrunch]" => 10,
		"<:scrunch:327935535278456833>" => 9,
		"( ( <:scrunch:327935535278456833> ) )" => 1
	}

	# Generic commands
	command(:hug, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << @@hugs_list.sample % event.user.display_name
	end
	command(:boop, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << rwe(@@scrunch_list)
	end
	command(:pet, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[happy doggo noises]"
	end
	command(:patpat, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[happy doggo noises]"
	end
	command(:brushie, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[happy doggo noises]"
	end
	command(:feed, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[happy munching doggo noises]"
	end
	command(:biscuit, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[happy munching doggo noises]"
	end
	command(:treat, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[happy munching doggo noises]"
	end
	command(:newspaper, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << @@newspaper_list.sample 
	end
	command(:spritz, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[unhappy doggo noises]"
	end
	command(:hose, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[miserable doggo noises]"
	end
	command(:wop, help_available: false) do |event, *args|
		break if !args[0].nil?
		event << "[unhappy wopped doggo noises]"
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop
		remove_command(:hug)
		remove_command(:boop)
		remove_command(:pet)
		remove_command(:patpat)
		remove_command(:brushie)
		remove_command(:feed)
		remove_command(:biscuit)
		remove_command(:treat)
		remove_command(:newspaper)
		remove_command(:spritz)
		remove_command(:hose)
		remove_command(:wop)
	end

end # Roleplay
end; end # Plugins; SurfBot



