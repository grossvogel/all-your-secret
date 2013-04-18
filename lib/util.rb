class Util
	FORMAT_DATETIME_DB = '%Y-%m-%d %H:%I:%M'
	FORMAT_DATE_DB = '%Y-%m-%d'

	@@keys = Hash.new(false)

	def self.stripe(odd_label = "odd", even_label = "even", key = "global")
		@@keys[key] = !@@keys[key]
		@@keys[key] ? odd_label : even_label
	end
end
