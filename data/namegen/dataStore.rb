# dataStore.rb
# Author: Natleyn
# Version: 1.0.0
# A store of all extra data used for name generation, so as not to clutter that file.

module SurfBot; module Plugins
module Namegen

	@@phone_pad_data = {
		"1" => [*('a'..'z')],
		"2" => ['a','b','c'],
		"3" => ['d','e','f'],
		"4" => ['g','h','i'],
		"5" => ['j','k','l'],
		"6" => ['m','n','o'],
		"7" => ['p','q','r','s'],
		"8" => ['t','u','v'],
		"9" => ['w','x','y','z'],
		"0" => [*('a'..'z')]
	}

	@@alphabet = [*('a'..'z')]

end # Namegen
end; end # Plugins; SurfBot
