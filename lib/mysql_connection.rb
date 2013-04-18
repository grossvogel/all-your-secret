require 'mysql2'

class MysqlConnection
	def initialize(host, port, schema, user, password)
		@connection = Mysql2::Client.new :host=>host, :username=>user, :password=>password, :database=>schema
	end

	def self.get(creds = nil)
		creds ||= $config[:database]
		MysqlConnection.new creds[:host], creds[:port], creds[:schema], creds[:user], creds[:password]
	end

	def is_open?
		@connection
	end

	def method_missing(method, *args)
		@connection.send method, *args
	end
end
