# namegen.rb
# Author: natleyn
# Version: 1.0.1
# Generates names through a variety of methods, the default being Markov.
#
# Changelog
# 1.0.2
#  - Added a method (sea2_gen_name / sea2_gen_suggestion) of generating names from pure random selection of consonants and vowels. May need tweaking.
# 1.0.1
#  - Added more ways to generate names- Markov (dataset not implemented yet) and Sea (a method of suggesting letters for use)
# 1.0.0
#  - Got basic functionality working and set up for expansion.

require_relative '../data/namegen/pitcockData'
require_relative '../data/extraFunctions'

module SurfBot; module Plugins
module Namegen
	extend Discordrb::Commands::CommandContainer
	def self.filename; "namegen.rb"; end

	@@DEFAULT_NUM_NAMES = 10

	# TODO: Initialize the starting letters in every hash somehow, or get an rwe setup to return a specific letter without it having an entry in @@markov_data
	weighted_letter_hash_maker = lambda do 
		temp_hash = {}
		[*('a'..'z')].each do |letter|
			temp_hash[letter] = 1
		end
		temp_hash
	end
	@@markov_data = Array.new(27) { Array.new(27) { weighted_letter_hash_maker.call } } 

	def self.get_markov_index(character)
		return (character.match?(/[A-Za-z]/)? character.upcase.ord%("A".ord)  : 0 )
	end

	def self.markov_namegen(num_names)
		output = "Try these out: "
		num_names.times do |index|
			state_a = 0
			state_b = 0
			next_letter = ""
			length = (rand(0..5)+3)
			name = ""
			length.times do
				# Generate a random letter according to weights
				cur_pos_weights = @@markov_data[state_a][state_b]
				next_letter = "#{rwe(cur_pos_weights)}"
				name += next_letter
	
				# Move on to next values for next letter
				state_a = state_b
				state_b = get_markov_index("#{next_letter.downcase}")
			end
			output << "#{name}#{((index < num_names-1) ? ', ' : '.' )}"
		end
		output
	end

	def self.pitcock_gen_name
		name = "#{Pitcock::gen_start}"
		num_mids = rand(0..100)%3
		num_mids.times do
			name << Pitcock::gen_middle
		end
		name << Pitcock::gen_end 
	end

	def self.pitcock_gen_name_bad
		name = "#{Pitcock::gen_start}"
		num_mids_a = (rand(0..100)%2+2)
		num_mids_a.times do
			num_mids_b = rand(0..100)%3
			num_mids_b.times do
				name << Pitcock::gen_middle
			end
			Pitcock::gen_end
		end
		name
	end

	def self.pitcock_namegen(num_names, bad_version)
		output = "Some names to ponder: "
		num_names.times do |index|
			output << "#{( bad_version ? pitcock_gen_name_bad : pitcock_gen_name )}#{index < num_names-1 ? ", " : "." }"
		end
		output
	end

	@@alphabet = [*('a'..'z')]

	def self.sea_gen_suggestion
		"Try using these: #{@@alphabet.sample}, #{@@alphabet.sample}, #{@@alphabet.sample}, #{@@alphabet.sample}."
	end
	
	def self.sea2_gen_name
		vowels = ['a','e','i','o','u','y']
		consonants = @@alphabet - vowels
		length = rand(3..10)
		name = "#{(rand(0..1) ? consonants.sample : vowels.sample )}".upcase
		length.times do
			if vowels.include?(name[-1])
				name << ( rand(0..100) < 80 ? consonants.sample : vowels.sample )
			else
				name << ( rand(0..100) < 80 ? vowels.sample : consonants.sample )
			end
		end
		name
	end
	def self.sea2_gen_suggestion(num_names)
		"How about these: #{(num_names.times.collect { sea2_gen_name } ) * ", "}"
	end

	command(:namegen,
		description: "Generates names through a variety of methods; default is IRC (Pitcock).\nOptions: markov, irc, shitty, sea"
		) do |event, *args|
		input = args[0..2]
		num_names = (args.select { |e| e.match? /\d+/ })[0].to_i
		num_names = ((num_names == 0 || num_names > 20) ? @@DEFAULT_NUM_NAMES : num_names)
		if (input.any? { |e| e.match? /markov/i })
			output = markov_namegen(num_names)
		elsif (input.any? { |e| e.match? /irc/i })
			output = pitcock_namegen(num_names, false)
		elsif (input.any? { |e| e.match? /shitty/i })
			output = pitcock_namegen(num_names, true)
		elsif (input.any? { |e| e.match? /sea\b/i })
			output = sea_gen_suggestion
		elsif (input.any? { |e| e.match? /sea2/i} )
			output = sea2_gen_suggestion(num_names)
		else
			output = pitcock_namegen(num_names, false)
		end
		event << output
	end

	def self.clean_up; end
	def self.save_data; end
	def self.stop
		remove_command(:namegen)
		@@markov_data = nil
	end

end # Namegen
end; end # Plugins; SurfBot
