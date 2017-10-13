module SurfBot; module Plugins
module Roll; module WMS
	@@WMS_effects = {
		2 => "Roll on this table at the start of each of your turns for the next minute, ignoring this result on subsequent rolls.",
		4 => "For the next minute, you can see any invisible creature if you have line of sight to it.",
		6 => "A **modron** chosen and controlled by the DM appears in an unoccupied space within 5 feet of you, then disappears 1 minute later.",
		8 => "You cast _fireball_ as a 3rd level spell, centered on yourself.",
		10 => "You cast _magic missile_ as a 5th level spell.",
		12 => "Roll a d10. Your height changes by a number of inches equal to the roll. If the roll is odd, you shrink. If the roll is even, you grow.",
		14 => "You cast _confusion_ centered on yourself.",
		16 => "For the next minute, you regain 5 hit points at the start of each of your turns.",
		18 => "You grow a long beard made of feathers that remains until you sneeze, at which point the feathers explode out from your face.",
		20 => "You cast _grease_ centered on yourself.",
		22 => "Creatures have disadvantage on saving throws against the next spell you cast in the next minute that involves a saving throw.",
		24 => "Your skin turns a vibrant shade of blue. A _remove curse_ spell can end this effect.",
		26 => "An eye appears on your forehead for the next minute. During that time, you have advantage on Wisdom (Perception) checks that rely on sight.",
		28 => "For the next minute, all your spells with a casting time of 1 action have a casting time of 1 bonus action.",
		30 => "You teleport up to 60 feet to an unoccupied space of your choice that you can see.",
		32 => "You are transported to the Astral Plane until the end of your next turn, after which time you return to the space you previously occupied or the nearest unoccupied space if that space is occupied.",
		34 => "Maximize the damage of the next damaging spell you cast within the next minute.",
		36 => "Roll a d10. Your age changes by a number of years equal to the roll. If the roll is odd, you get younger (minimum 1 year old). If the roll is even, you get older.",
		38 => "1d6 **flumphs** controlled by the DM appear in unoccupied spaces within 60 feet of you and are frightened of you. They vanish after 1 minute.",
		40 => "You regain 2d10 hit points.",
		42 => "You turn into a potted plant until the start of your next turn. While a plant, you are incapacitated and have vulnerability to all damage. If you drop to 0 hit points, your pot breaks, and your form reverts.",
		44 => "For the next minute, you can teleport up to 20 feet as a bonus action on each of your turns.",
		46 => "You cast _levitate_ on yourself.",
		48 => "A unicorn controlled by the DM appears in a space within 5 feet of you, then disappears 1 minute later.",
		50 => "You can't speak for the next minute. Whenever you try, pink bubbles float out of your mouth.",
		52 => "A spectral shield hovers near you for the next minute, granting you a +2 bonus to AC and immunity to magic missile.",
		54 => "You are immune to being intoxicated by alcohol for the next 5d6 days.",
		56 => "Your hair falls out but grows back within 24 hours.",
		58 => "For the next minute, any flammable object you touch that isn't being worn or carried by another creature bursts into flame.",
		60 => "You regain your lowest-level expended spell slot.",
		62 => "For the next minute, you must shout when you speak.",
		64 => "You cast _fog cloud_, centered on yourself.",
		66 => "Up to three creatures you choose within 30 feet of you take 4d10 lightning damage.",
		68 => "You are frightened by the nearest creature until the end of your next turn.",
		70 => "Each creature within 30 feet of you becomes invisible for the next minute. The invisibility ends on a creature when it attacks or casts a spell.",
		72 => "You gain resistance to all damage for the next minute.",
		74 => "A random creature within 60 feet of you becomes poisoned for 1d4 hours.",
		76 => "You glow with bright light in a 30-foot radius for the next minute. Any creature that ends its turn within 5 feet of you is blinded until the end of its next turn.",
		78 => "You cast _polymorph_ on yourself. If you fail the saving throw, you turn into a sheep for the spell's duration.",
		80 => "Illusory butterflies and flower petals flutter in the air within 10 feet of you for the next minute.",
		82 => "You can take one additional action immediately.",
		84 => "Each creature within 30 feet of you takes 1d10 necrotic damage. You regain hit points equal to the sum of the necrotic damage dealt.",
		86 => "You cast _mirror image_.",
		88 => "You cast _fly_ on a random creature within 60 feet of you.",
		90 => "You become invisible for the next minute. During that time, other creatures can't hear you. The invisibility ends if you attack or cast a spell.",
		92 => "If you die within the next minute, you immediately come back to life as if by the _reincarnate_ spell.",
		94 => "Your size increases by one size category for the next minute.",
		96 => "You and all creatures within 30 feet of you gain vulnerability to piercing damage for the next minute.",
		98 => "You are surrounded by faint, ethereal music for the next minute.",
		100 => "You regain all expended sorcery points.",
	}

	def self.roll_WMS
		roll = rand(1..100)
		target = 2
		while(roll > target) ; target += 2; end
		return "Rolled an #{roll}: #{@@WMS_effects[target]}"
	end	
end; end # WMS; Roll
end; end # Plugins; SurfBot
