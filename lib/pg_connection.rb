require 'pg'

class PgConnection 
	def initialize(host, port, schema, user, password)
		@connection = PG::Connection.open(
			host: host, port: port, user: user, password: password, dbname: schema
		)
	end

	def is_open?
		@connection
	end

	def query(sql)
		result = @connection.exec(sql)
		if block_given?
			result.each do |row|
			puts row.inspect
				record = Hash.new
				row.each do |value|
					record[value[0]] = value[1]
				end
				yield record
			end
		end
	end

	def escape(str)
		@connection.escape_string(str)
	end

	def last_id(table)
		id = nil
		self.query("select CURRVAL(pg_get_serial_sequence('#{escape(table)}','id')) as id;") do |record|
			id = record['id'].to_i
		end
		id
	end

	def close
		@connection.close
	end
end
