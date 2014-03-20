require 'mysql2'

class MysqlConnection
	def initialize(host, port, schema, user, password)
		@connection = Mysql2::Client.new :host=>host, :username=>user, :password=>password, :database=>schema
	end

	def is_open?
		@connection
	end

	def query(sql)
		rs = @connection.query(sql)
		if block_given?
			rs.each do |record|
				yield record
			end
		end
	end

	def escape(str)
		@connection.escape(str)
	end

	def last_id(table)
		@connection.last_id
	end

	def close
		@connection.close
	end
end
