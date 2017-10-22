# fortune.rb
# Author: natleyn
# Version: 1.0.0
# Contains the background info for fortune (yes/no responses) and random choice (pick from user provided list)

require_relative '../surfBotInfo2'

module SurfBot; module Plugins
module Fortune

	@@fortune_responses = [
		[
			"Yes.",
			"Yes! Yes!",
			"Indubitably.",
			"#{SurfBot.surf_name} thinks so.",
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
	
	@@random_responses = [
		"Try `%s`.",
		"How about `%s`?",
		"`%s`, maybe.",
		"Pony should `%s`.",
		"I think `%s` would make pony happy.",
		"My gems point towards `%s`.",
		"Uhh... #{SurfBot.surf_name} doesn't know. `%s`?",
		"Umm... #{SurfBot.surf_name} isn't sure. Maybe... `%s`?",
		"I had a dream where gems surrounded `%s`.",
		"`%s` sounds good."
	]

	
	def self.pick_random_option(list_string)
		options = list_string.gsub(/ or /, ',').gsub(/,\s*,+/,',').gsub(/\?/,'')
		lists = []
		choices = ""
		options.split(';').each do |option_list|
			choices << "#{option_list.split(',').sample.strip}, "
		end
		choices.slice(0..-3).strip
	end
end # Fortune
end; end # Plugins; SurfBot
