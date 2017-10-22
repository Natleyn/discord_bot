# domtCards.rb
# Author: Natleyn, TODO: the guy who made the cards
# Version: 1.0.0
# Holds the information on cards in the Deck of Many Things homebrew edition for D&D5e.

module SurfBot; module Plugins
module DrawCards; module DoMT
	@@domt_cards = {
		"Two of Clubs" => "Idiot\n```Permanently reduce your Intelligence by 1d4 + 1 (to a minimum score of 1). You can draw one additional card beyond your declared draws.```\n",
		"Three of Clubs" => "Chance\n```Every time you flip a coin, you will always lose the outcome. In any game that relies on chance, you are at disadvantage. Only a wish spell or divine intervention can end this suffering.```\n",
		"Four of Clubs" => "Idol\n```You become the idol of a cult that believes you need to be sacrificed for them to be able to achieve their goals. The cult is aware of your location when you drew the card, as well as your name and race.```\n",
		"Five of Clubs" => "Cold\n```A shivering wind emanates from the cold towards a randomly determined limb. You take 55 (10d10) cold damage, and the limb freezes. If the damage is equal to or greater than half your health, the limb falls off.```\n",
		"Six of Clubs" => "Consort\n```A nonplayer character of the DM's choice becomes madly in love with you and obsesses over you. The identity of your new love isn't known until the NPC or someone else reveals it. Nothing less than a wish spell or Divine Intervention can end the NPC's love toward you.```\n",
		"Seven of Clubs" => "Shift\n```Any creatures within 30ft must succeed on a DC 19 intelligence saving throw or be forced to switch bodies with another creature that also failed the saving throw. If less than two people fail their saving throws, this effect does not occur. You obtain their strength, dexterity, and constitution but retain your class features and intelligence, wisdom, charisma. Only divine intervention, a wish spell, or a magic jar spell can end this effect.```\n",
		"Eight of Clubs" => "Pack\n```A gnoll war band is alerted to your location, thinking the signal is from Yeenoghu, and begins marching towards the location the card was drawn.```\n",
		"Nine of Clubs" => "Night\n```When you next fall asleep, a monster comes to you- as in the effects of a dream spell- and delivers a threatning message. In 2d4 days, the monster confronts you and attempts to kill you. If this succeeds, your soul belongs to the creature, and you cannot be brought back without killing the creature.```\n",
		"Ten of Clubs" => "Blood\n```Any blood that touches your body turns to acid. Whenever you are hit by a melee attack, you will take 23 (5d8) acid damage. This effect can be lessened by 1d8 for every greater restoration that is cast on you, or ended instantly by divine intervention or a wish spell.```\n",
		"Jack of Clubs" => "Skull\n```You summon an avatar of death: a ghostly humanoid Skeleton, clad in a tattered black robe and carrying a spectral scythe. It appears in a space of the DM's choosing within 10 feet of your character and attacks you, warning all others that you must win the battle alone. The avatar fights until you die or it drops to 0 hit points, whereupon it disappears. If anyone tries to help you, the helper summons its own avatar of death. A creature slain by an avatar of death can't be restored to life.```\n",
		"Queen of Clubs" => "Flames\n```A powerful devil becomes your enemy. The devil seeks your ruin and plagues your life, savoring your suffering before attempting to slay you. This enmity lasts until either you or the devil dies.```\n",
		"King of Clubs" => "The Void\n```This black card spells disaster. Your soul is drawn from your body and contained in an object in a place of the DM's choice. One or more powerful beings guard the place. While your soul is trapped in this way, your body is Incapacitated. A wish spell can't restore your soul, but the spell reveals the location of the object that holds it. You draw no more cards.```\n",
		"Ace of Clubs" => "Talons\n```Every magic item you wear or carry disintegrates. Artifacts in your possession aren't destroyed but do Vanish.```\n",
		
		"Two of Diamonds" => "Comet\n```If you single-handedly defeat the next hostile monster or group of Monsters you encounter, you gain experience points enough to gain one level. Otherwise, this card has no effect.```\n",
		"Three of Diamonds" => "Meteorite\n```For the next 2d6 days, you gain the effects of a Melf's Minute Meteors spell. The meteors replenish instantly whenever they are used.```\n",
		"Four of Diamonds" => "Galaxy\n```The knowledge of a technology from a far away world flows into your mind, and you know the materials needed and how to craft the object. This could be anything from a gun to a paperclip.```\n",
		"Five of Diamonds" => "Nebula\n```As an action, you can cast the Gaseous Form spell on yourself, ignoring material components. This ability can be used 10 times.```\n",
		"Six of Diamonds" => "Pulsar\n```A pulse of heaing energy surges through you, healing you by 33 (6d10) points. This healing surge occurs at exactly the same time as you drew this card, every day, for a year. Any effect that would negate or stop healing only stops the healing from this effect on that particular day.```\n",
		"Seven of Diamonds" => "Astronomer\n```You become aware of a cosmic event happening somewhere in the universe, and you are able to accurately describe the events as they occur. When this event is over you gain a small fragment of rock, which can be used to view the event again.```\n",
		"Eight of Diamonds" => "Space\n```You gain the ability to instantly teleport you and anyone touching you, as a reaction, to your home at the time of drawing the card. This ability can be used 1d10+1 times.```\n",
		"Nine of Diamonds" => "Quasar\n```Bright light shines from this card when you draw it, blinding you for 1d10 days. Once the blind effect ends, you gain blindsense at a range of 20ft.```\n",
		"Ten of Diamonds" => "Planet\n```When this card is drawn, you gain the effects of a meld with stone spell and sink into the ground if there is stone within 10ft of where you are standing. After the duration of the spell, you gain a burrowing speed equal to 10ft, but you do not leave a space behind you.```\n",
		"Jack of Diamonds" => "Star\n```Increase one of your Ability Scores by 2. The score can exceed 20 but can't exceed 24.```\n",
		"Queen of Diamonds" => "Moon\n```You are granted the ability to cast the Wish spell 1d3 times.```\n",
		"King of Diamonds" => "Sun\n```You gain 50,000 XP, and a wondrous item (which the DM determines randomly) appears in your hands.```\n",
		"Ace of Diamonds" => "Vizier\n```At any time you choose within one year of drawing this card, you can ask a question in meditation and mentally receive a truthful answer to that question. Besides information, the answer helps you solve a puzzling problem or other dilemma. In other words, the knowledge comes with Wisdom on how to apply it.```\n",
	
		"Two of Hearts" => "Gem\n```Twenty-five pieces of jewelry worth 2,000 gp each or fifty gems worth 1,000 gp each appear at your feet.```\n",
		"Three of Hearts" => "Lock\n```Each of your possesions that can be opened and closed comes under the effect of an arcane lock spell. The phrase to temporaraly disable it is the next word spoken by you, you are not aware of this until you next speak.```\n",
		"Four of Hearts" => "Beefeater\n```You gain proficency with cook's utensils and double your proficency bonus on checks made with this skill. In addition, any food prepared by you is cleansed of any disease and/or poison.```\n",
		"Five of Hearts" => "Executioner\n```The next hostile entity you strike takes an additional 55 (10d10) force damage as a ghostly visage strikes it. If this damage kills it, the creature is beheaded and cannot be brought back to life.```\n",
		"Six of Hearts" => "Guard\n```A mastiff appears at your side and refuses to leave your side until death. The hound is invisible to all creatures except you, and can’t be harmed. At the start of each of your turns, the hound can attempt to bite one creature within 5 feet of it that is hostile to you. The hound’s attack bonus is equal to your spellcasting ability modifier (if you have one) + your proficiency bonus. On a hit, it deals 2d8 piercing damage.```\n",
		"Seven of Hearts" => "Heir\n```If you are male, the last female that you touched becomes pregnant with your baby. If you are female, you become pregnant with the baby of the last male you touched.```\n",
		"Eight of Hearts" => "Diplomat\n```A hostile nonplayer character of the DM's choice becomes nonhostle and takes a liking to you. The identity of your new enemy isn't known until the NPC or someone else reveals it. Nothing less than a wish spell or Divine Intervention can end the NPC's kindness towards you.```\n",
		"Nine of Hearts" => "Alchemist\n```Over the next 1d4 days all of your gold coins turn to platinum, all electrum coins turn to gold, all silver coins turn to electrum and al copper coins turn to silver.```\n",
		"Ten of Hearts" => "Priest\n```A god of the DM's choosing appears as a visage in front of the player. Only they can see or hear it, and they may ask 1d4 questions before it dissapates. The god does not have to answer truthfully, but this may depend on the god that answered the summons.```\n",
		"Jack of Hearts" => "Knight\n```You gain the service of a 4th-level Fighter who appears in a space you choose within 30 feet of you. The Fighter is of the same race as you and serves you loyally until death, believing the fates have drawn him or her to you. You control this character.```\n",
		"Queen of Hearts" => "Key\n```A rare or rarer Magic Weapon with which you are proficient appears in your hands. The DM chooses the weapon.```\n",
		"King of Hearts" => "Throne\n```You gain proficiency in the Persuasion skill, and you double your proficiency bonus on checks made with that skill. In addition, you gain rightful ownership of a small keep somewhere in the world. However, the keep is currently in the hands of Monsters, which you must clear out before you can claim the keep as yours.```\n",
		"Ace of Hearts" => "The Fates\n```Reality's fabric unravels and spins anew, allowing you to avoid or erase one event as if it never happened. You can use the card's magic as soon as you draw the card, or at any other time before you die.```\n",
	
		"Two of Spades" => "Balance\n```Your mind suffers a wrenching alteration, causing your alignment to change. Lawful becomes chaotic, good becomes evil, and vice versa. If you are true neutral or unaligned, this card has no effect on you.```\n",
		"Three of Spades" => "Betrayer\n```At any time you choose within one year of drawing this card, you can ask a question in meditation and mentally receive an answer to that question. The answer appears truthful but in actuality will be a lie designed to lead you to your death or fail your objectives.```\n",
		"Four of Spades" => "Liar\n```For the next 2d4 days, you are unable to lie to others, with one catch: you don't know you're not lying. While you hear your lie, all others hear the truth. This effect does not prevent your character from learning this fact.```\n",
		"Five of Spades" => "Impersonator\n```An exact replica of you- in your current physical state- appears in the world with the sole goal of tracking you down and replacing you. They have The same class (although they can be a different archetype) and stats, though their alignment is the opposite of yours. They know your location at the time of drawing the card.```\n",
		"Six of Spades" => "Lost\n```You become trapped within a labrynthine demiplane as if a Maze spell had been cast on you. Make three DC20 Intelligence checks: if you succeed on 3, you are trapped for an hour; if you fail on 3, you are trapped for ten days. If you roll in between, you are trapped for an appropriate time of the DM's choosing between those two times.```\n",
		"Seven of Spades" => "Gambler\n```The card instantly turns into a coin within your hand and you feel an overwhelming urge to flip it. On heads, your money doubles and appears at your feet. On tails, your gold dissapears.```\n",
		"Eight of Spades" => "Pheonix\n```You immediately die, exploding as 9th level fireball spell is cast, centered on yourself (DC 20 for anyone within the 20ft radius or take 56 (16d6) fire damage), and then come back to life as if by the Reincarnate spell.```\n",
		"Nine of Spades" => "Doctor\n```You are transported 150 years into the past, to the same place or nearest available space. After 10 years in the new time zone, you are transported forward in time to exactly 10 seconds after you drew the card.```\n",
		"Ten of Spades" => "Wind\n```Every 10 hours for the next 1d100 hours, you are transported to a random settlement of a population greater than 1000, within 250 miles, centered on where you drew the card. The first transport happens instantly, and at the end of the 1d100 hours you are transported back to the location or nearest available space that the card was drawn.```\n",
		"Jack of Spades" => "Rogue\n```A nonplayer character of the DM's choice becomes hostile toward you. The identity of your new enemy isn't known until the NPC or someone else reveals it. Nothing less than a wish spell or Divine Intervention can end the NPC's hostility toward you.```\n",
		"Queen of Spades" => "Euryale\n```The card's medusa-like visage curses you. You take a -2 penalty on saving throws while cursed in this way. Only a god or the magic of The Fates card can end this curse.```\n",
		"King of Spades" => "Ruin\n```All forms of wealth that you carry or own, other than Magic Items, are lost to you. Portable property vanishes. Businesses, buildings, and land you own are lost in a way that alters reality the least. Any documentation that proves you should own something lost to this card also disappears.```\n",
		"Ace of Spades" => "Donjon\n```You disappear and become entombed in a state of suspended animation in an extradimensional sphere. Everything you were wearing and carrying stays behind in the space you occupied when you disappeared. You remain imprisoned until you are found and removed from the sphere. You can't be located by any Divination magic, but a wish spell can reveal the location of your prison. You draw no more cards.```\n",
	
		"Joker:tm:" => "Fool\n```You lose 10,000 XP, discard this card, and draw from the deck again, counting both draws as one of your declared draws. If losing that much XP would cause you to lose a level, you instead lose an amount that leaves you with just enough XP to keep your level.```\n",
		"Joker" => "Jester\n```You gain 10,000 XP, or you can draw two additional cards beyond your declared draws.```\n"
	}

	def self.draw_card(card_name)
		@@domt_cards[card_name]
	end

end; end # DoMT; DrawCards
end; end # Plugins; SurfBot
