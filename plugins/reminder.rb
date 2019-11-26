# reminder.rb
# Author: natleyn
# Version: 0.0.1
# Stores, lists, and reminds people about messages at a given time specified in the command.


module SurfBot; module Plugins
module Reminder
	extend Discordrb::Commands::CommandContainer
	def self.filename; "reminder.rb"; end

	@@reminder_data = {}


	def self.init_reminders
		# TODO: Read from data file
		puts "TODO: Load data"
	end

	def self.save_reminders
		# TODO: Save data to file
		puts "TODO: Save data"
	end


	def self.command_handler(command, user, time, msg)
		result = ""
		case command
		when /add/i,
			result = add_reminder(user, time, msg)
		when /rem(ove)?/i
			result = remove_reminder(user, msg)
		when /list/i
			result = list_reminders(user)
		else
			result = "print help here I guess"
		end
		result
	end


	def self.add_reminder(user, time, message)
		"Add"
	end

	def self.remove_reminder(user, msgnum)
		"Remove"
	end

	def self.list_reminders(user)
		"List"
	end


	command(:reminder,
		description: "Set a reminder for #{SurfBot.surf_name} to remind you about in the future.\nTime format: 'HHhMMmSSs', no quotes or spaces.",
		) do |event, *args|
		puts "#{args}"
		event << "Command: #{command_handler(args[0], event.user, args[1], event.message)}"
	end


	#def self.init; end
	def self.clean_up; end
	def self.save_data
		# TODO: Add file saving here
		save_reminders
	end
	def self.stop
		remove_command(:reminder)
	end


end # Reminder
end; end # Plugins; SurfBot
