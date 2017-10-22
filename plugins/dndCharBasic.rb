# dndCharBasic.rb
# Author: natleyn
# Version: 2.0.0
# Puts out basic D&D 5e character ideas; includes options for MLP characters.

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

	@@gendersMaxWeight = 100
	@@genders = {
		"male" => 45,
		"female" => 45,
		"female-presenting male" => 5,
		"male-presenting female" => 5
	}

	@@racesMaxWeight=100
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

	@@subclasses = {
		"Barbarian" => ["Berserker", "Totem Warrior"],
		"Bard" => ["College of Lore", "College of Valor"],
		"Cleric" => ["Knowledge", "Life", "Light", "Moon", "Nature", "Tempest", "Trickery", "War"],
		"Druid" => ["Circle of the Land", "Circle of the Moon"],
		"Fighter" => ["Champion", "Battle Master", "Eldritch Knight"],
		"Monk" => ["Way of the Open Hand", "Way of Shadow", "Way of the Four Elements"],
		"Paladin" => ["Oath of Devotion", "Oath of the Ancients", "Oath of Vengeance"],
		"Ranger" => ["Hunter", "Beast Master"],
		"Rogue" => ["Thief", "Assassin", "Arcane Trickster"],
		"Sorcerer" => ["Wild Magic", "Draconic Bloodline", "Alicorn Ancestry"],
		"Warlock" => ["Archfey Patron", "Fiend Patron", "Great Old One Patron", "Changeling Queen Patron"],
		"Wizard" => ["Abjuration", "Conjuration", "Divination", "Enchantment", "Evocation", "Illusion", "Necromancy", "Transmutation" ]
	}

	def DNDCharBasic::rwe(weightedHash, totalWeight)
		sum = 0
		rng = rand(1..totalWeight)
		weightedHash.each do |key, value|
			sum += value
			if rng <= sum then
				return key
			end
		end
	end

	@@suggestions_pony = ["%s %s %s, %s %s?", "Pony might like a %s %s %s, who is %s %s.", "Pony should make a %s %s %s who is a %s %s!"]
	def DNDCharBasic::rngPony()
		charAlign = @@alignments.sample
		charGender = rwe(@@genders,@@gendersMaxWeight)
		charRace = rwe(@@pony_races,@@racesMaxWeight)
		charClass = @@classes.sample
		charSubclass = @@subclasses[charClass].sample
		return @@suggestions_pony.sample % [charAlign, charGender, charRace, charSubclass, charClass]
	end

	command(:dndpone,
		description: "Get an idea for a MLP D&D character.",
		usage: "#{@surf_cmd_prefix}dndchar") do |event|
		event << rngPony
	end

	def self.clean_up; end
	def self.stop; remove_command(:dndpone); end

end # DNDCharBasic
end; end # Plugins; SurfBot
