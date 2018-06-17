# dndCharBasic.rb
# Author: natleyn
# Version: 2.2.0
# Puts out basic D&D 5e character ideas; includes options for MLP characters.
# Changelog:
# 2.2.0
#  - Added PHB races and methods to get them in output
#  - Added save_data method for compatibility with plugin system
# 2.0.1
#  - Moved rwe (random weighted element) to data/extraFunctions.rb as part of the Kernel module

require_relative '../data/extraFunctions'

module SurfBot; module Plugins
module DNDCharBasic
	extend Discordrb::Commands::CommandContainer
	def self.filename; "dndCharBasic.rb"; end

	@@alignments = [
		"Lawful Good",
		"Neutral Good",
		"Chaotic Good",
		"Lawful Neutral",
		"True Neutral",
		"Chaotic Neutral",
		"Lawful Evil",
		"Neutral Evil",
		"Chaotic Evil"
	]

	@@genders_max_weight = 100
	@@genders = {
		"male" => 45,
		"female" => 45,
		"female-presenting male" => 5,
		"male-presenting female" => 5
	}

	@@phb_races = [
		"Dwarf",
		"Elf",
		"Halfling",
		"Human",
		"Dragonborn",
		"Gnome",
		"Half-Elf",
		"Half-Orc",
		"Tiefling"
	]
	@@phb_subraces = {
		"Dwarf" => ["Hill","Mountain"],
		"Elf" => ["High","Wood","Dark"],
		"Halfling" => ["Lightfoot","Stout"],
		"Human" => [""],
		"Dragonborn" => ["Black","Blue","Brass","Bronze","Copper","Gold","Green","Red","Silver","White"],
		"Gnome" => ["Forest","Rock"],
		"Half-Elf" => [""],
		"Half-Orc" => [""],
		"Tiefling" => [""]
	}


	@@pony_races_max_weight=100
	@@pony_races = {
		"Earth Pony" => 13,
		"Pegasus" => 13,
		"Unicorn" => 13,
		"Bat Pony" => 10,
		"Crystal Pony" => 10,
		"Seapony" => 10,
		"Zebra" => 7,
		"Changeling" => 5,
		"Gryphon" => 7,
		"Breezie" => 7,
		"Minotaur" => 5
	}


	@@classes = [
		"Barbarian",
		"Bard",
		"Cleric",
		"Druid",
		"Fighter",
		"Monk",
		"Paladin",
		"Ranger",
		"Rogue",
		"Sorcerer",
		"Warlock",
		"Wizard"
	]
	@@phb_subclasses = {
		"Barbarian" => ["Berserker", "Totem Warrior"],
		"Bard" => ["College of Lore", "College of Valor"],
		"Cleric" => ["Knowledge", "Life", "Light", "Moon", "Nature", "Tempest", "Trickery", "War"],
		"Druid" => ["Circle of the Land", "Circle of the Moon"],
		"Fighter" => ["Champion", "Battle Master", "Eldritch Knight"],
		"Monk" => ["Way of the Open Hand", "Way of Shadow", "Way of the Four Elements"],
		"Paladin" => ["Oath of Devotion", "Oath of the Ancients", "Oath of Vengeance"],
		"Ranger" => ["Hunter", "Beast Master"],
		"Rogue" => ["Thief", "Assassin", "Arcane Trickster"],
		"Sorcerer" => ["Wild Magic", "Draconic Bloodline"],
		"Warlock" => ["Archfey Patron", "Fiend Patron", "Great Old One Patron"],
		"Wizard" => ["Abjuration", "Conjuration", "Divination", "Enchantment", "Evocation", "Illusion", "Necromancy", "Transmutation" ]
	}
	@@pony_subclasses = {
		"Barbarian" => [],
		"Bard" => [],
		"Cleric" => [],
		"Druid" => [],
		"Fighter" => [],
		"Monk" => [],
		"Paladin" => [],
		"Ranger" => [],
		"Rogue" => [],
		"Sorcerer" => ["Alicorn Ancestry"],
		"Warlock" => ["Changeling Queen Patron"],
		"Wizard" => [] 
	}

	@@suggestions_pony = ["%s %s %s, %s %s?", "Pony might like a %s %s %s, who is a %s %s.", "Pony should make a %s %s %s who is a %s %s!"]
	def DNDCharBasic::rng_pony()
		charAlign = @@alignments.sample
		charGender = rwe(@@genders,@@genders_max_weight)
		charRace = rwe(@@pony_races,@@pony_races_max_weight)
		charClass = @@classes.sample
		charSubclass = (@@phb_subclasses[charClass] + @@pony_subclasses[charClass]).sample
		return @@suggestions_pony.sample % [charAlign, charGender, charRace, charSubclass, charClass]
	end
	# Alignment gender subrace race, subclass class 
	@@suggestions_phb = ["How about a %s %s %s%s, %s %s?", "Try a %s %s %s%s, a %s %s."]
	def self.rng_phb_char
		char_align = @@alignments.sample
		char_gender = rwe(@@genders,@@genders_max_weight)
		char_race = @@phb_races.sample
		char_subrace = @@phb_subraces[char_race].sample
		char_class = @@classes.sample
		char_subclass = @@phb_subclasses[char_class].sample
		return @@suggestions_phb.sample % [char_align, char_gender, (char_subrace.to_s.strip.empty? ? char_subrace : "#{char_subrace} " ), char_race, char_subclass, char_class]
	end

	command(:dndpone,
		description: "Get an idea for a MLP D&D character.",
		usage: "#{@surf_cmd_prefix}dndpone") do |event|
		event << rng_pony
	end
	command(:dndchar,
		description: "Get an idea for a D&D character using D&D5e PHB info.",
		usage: "#{@surf_cmd_prefix}dndchar") do |event|
		event << rng_phb_char
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop
		remove_command(:dndpone)
		remove_command(:dndchar)
	end

end # DNDCharBasic
end; end # Plugins; SurfBot
