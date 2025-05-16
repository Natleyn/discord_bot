# namegen.rb
# Author: natleyn
# Version: 1.0.3
# Generates names through a variety of methods, the default being Markov.
#
# Changelog
# 1.0.4
#  - Added message when providing invalid generation options. Refined help information.
# 1.0.3
#  - Added phone name generation, based off the letters assigned to numbers on phone number pad text entry systems.
# 1.0.2
#  - Added a method (sea2_gen_name / sea2_gen_suggestion) of generating names from pure random selection of consonants and vowels. May need tweaking.
# 1.0.1
#  - Added more ways to generate names- Markov (dataset not implemented yet) and Sea (a method of suggesting letters for use)
# 1.0.0
#  - Got basic functionality working and set up for expansion.

require_relative '../data/namegen/pitcockData'
require_relative '../data/namegen/planegeaData'
require_relative '../data/namegen/dataStore'
require_relative '../data/extraFunctions'

module SurfBot; module Plugins
module Namegen
	extend Discordrb::Commands::CommandContainer
	def self.filename; "namegen.rb"; end

	@@DEFAULT_NUM_NAMES = 10
	@@PLUGIN_OPTIONS = "markov, irc, phone, planegea, pomni, sea, sea2, shitty"

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

	def self.markov_namegen(num_names)
		return "WIP"
	end

	def self.phone_pad_gen_name
		name_length = rand(4..10)
		numbers = rand(0..9_999_999_999).to_s.rjust(10,"0")
		name = ""
		name_length.times do |num|
			name = @@phone_pad_data[numbers[-num]].sample + name
		end
		name.capitalize
	end

	def self.phone_pad_namegen(num_names)
		output = "Try one of these on: "
		num_names.times do |index|
			output << "#{phone_pad_gen_name}#{index < num_names-1 ? ", " : "." }"
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

	@@planegea_length = -1
	@@planegea_length_text = "mixed length"

	def self.planegea_gen_name
		name = "#{Planegea::gen_syllable}"
		do_mid = @@planegea_length == -1 ? rand(0..1) : @@planegea_length
		do_mid.times do
			name << Planegea::gen_syllable
		end
		name << Planegea::gen_end
		name.capitalize!
	end

	def self.planegea_namegen(num_names)
		output = "Some #{@@planegea_length_text} names from Planegea, in times prehistoric: "
		num_names.times do |index|
			output << "#{planegea_gen_name}#{index < num_names -1 ? ", " : "."}"
		end
		output
	end

	def self.sea_gen_suggestion
		"Try using these: #{@@alphabet.sample}, #{@@alphabet.sample}, #{@@alphabet.sample}, #{@@alphabet.sample}."
	end

	def self.pomni_gen_suggestion
		"What do you think of #{@@alphabet.sample}#{@@alphabet.sample}#{@@alphabet.sample}#{@@alphabet.sample}#{@@alphabet.sample}?"
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
		description: "Generates names through a variety of methods; default is IRC (Pitcock). Min 1, Max 20, default of 10.\nUsage: `;namegen {style} {number of names}`\nOptions: #{@@PLUGIN_OPTIONS}"
		) do |event, *args|
		input = args[0..5]
		num_names = (args.select { |e| e.match? /\d+/ })[0].to_i
		num_names = ((num_names < 1 || num_names > 20) ? @@DEFAULT_NUM_NAMES : num_names)
		if (input.any? { |e| e.match? /^markov$/i })
			output = markov_namegen(num_names)
		elsif (input.any? { |e| e.match? /^phone$/i })
			output = phone_pad_namegen(num_names)
		elsif (input.any? { |e| e.match? /^shitty$/i })
			output = pitcock_namegen(num_names, true)
		elsif (input.any? { |e| e.match? /^planegea$/i })
			length_flag = (args.select { |e| e.match? /(mixed|long|short)/i })[0]
			if("mixed".eql?(length_flag))
				@@planegea_length = -1
				@@planegea_length_text = "mixed length"
			elsif ("long".eql?(length_flag))
				@@planegea_length = 1
				@@planegea_length_text = "long"
			elsif ("short".eql?(length_flag))
				@@planegea_length = 0
				@@planegea_length_text = "short"
			end
			output = planegea_namegen(num_names)
		elsif (input.any? { |e| e.match? /^sea$/i })
			output = sea_gen_suggestion
		elsif (input.any? { |e| e.match? /^sea2$/i} )
			output = sea2_gen_suggestion(num_names)
		elsif (input.any? { |e| e.match? /^pomni$/i } )
			output = pomni_gen_suggestion
		else
			if(!input.nil? && !input.empty?) 
				output = "Unknown option: \"#{input[0]}\". Options: #{@@PLUGIN_OPTIONS}"
			else
				output = pitcock_namegen(num_names, false)
			end
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
