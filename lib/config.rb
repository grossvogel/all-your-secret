$config = {
	:database => {
		:host => 'localhost',
		:port => 3306,
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

#	App Fog Database Configuration 
if ENV['VCAP_SERVICES']
	$creds = JSON.parse(ENV['VCAP_SERVICES'])['mysql-5.1'].first['credentials']
	$config[:database] = {
		:host => $creds['host'],
		:port => $creds['port'],
		:schema => $creds['name'],
		:user => $creds['user'],
		:password => $creds['password'],
	}
end
