class DBConnection
	def self.get(creds = nil)
		creds ||= $config[:database]
		if creds[:adapter] == :mysql
			MysqlConnection.new creds[:host], creds[:port], creds[:schema], creds[:user], creds[:password]
		elsif creds[:adapter] == :pg
			PgConnection.new creds[:host], creds[:port], creds[:schema], creds[:user], creds[:password]
		else
			raise 'No database adapter found'
		end
	end
end
