module DnD
	@@stats = [
		"strength",
		"dexterity",
		"constitution",
		"intelligence",
		"wisdom",
		"charisma",
	]

	def DnD.rollHighLow()
		high = @@stats.sample
		lowList = @@stats.reject { |stat| stat == high }
		return [ high, lowList.sample ]
	end
end
