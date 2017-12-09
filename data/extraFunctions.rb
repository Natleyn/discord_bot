# extraFunctions.rb
# Author: natleyn
# Version: 1.1.0
# Holds some functions I find useful enough to make available everywhere.

module Kernel
	def remove_lowest(input, to_remove=1)
		return if input.to_s.strip.nil? || to_remove <= 0
		min = input[0]
		input.each do |num|; min = num if num < min; end
		if ((to_remove-1)>0)
			remove_lowest( (input[0...input.index(min)] + input[(input.index(min)+1)..-1]), (to_remove-1))
		else
			return (input[0...input.index(min)] + input[(input.index(min)+1)..-1])
		end
	end

	def remove_highest(input, to_remove=1)
		return if input.to_s.strip.nil? || to_remove <= 0
		max = input[0]
		input.each do |num|; max = num if num > max; end
		if ((to_remove-1)>0)
			remove_highest( (input[0...input.index(max)] + input[(input.index(max)+1)..-1]), (to_remove-1))
		else
			return (input[0...input.index(max)] + input[(input.index(max)+1)..-1])
		end
	end

	# random weighted element - draws from a weighted hash of (key, weight) pairs
	def rwe(weighted_hash, total_weight=-1)
		max = 0
		if total_weight == -1
			weighted_hash.each do |key, value|; max += value; end
		else
			max = total_weight
		end
		sum = 0
		rng = rand(1..max)
		weighted_hash.each do |key, value|
			sum += value
			if random_number <= sum
				return key
			end
		end
	end
end
