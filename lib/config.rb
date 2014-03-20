$config = {
	:database => {
		:adapter => :pg,
		:host => 'localhost',
		:port => 5432,
		:schema => 'all_your_secret',
		:user => 'all_your_secret',
		:password => 'asdfasoieface',
	},
	:libraries => [
		'lib',
		'lib/model',
	],
	:secret_expiration_days => 7,
}

#	override with settings from ENV
$config.each do |key, val|
	$config[key] = ENV[key.to_s] if ENV.include?(key.to_s)
end

if ENV['DATABASE_URL']
	ENV['DATABASE_URL'] =~ %r|^postgres://(\S*):(\S*)@(\S*):(\S*)/(\S*)$|
	$config[:database] = {
		:adapter => :pg,
		:host => $3,
		:port => $4,
		:schema => $5,
		:user => $1,
		:password => $2,
	}
end
