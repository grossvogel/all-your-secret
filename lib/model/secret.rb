module Model 
	class Secret
		attr_reader :id, :token, :encrypted, :created

		def initialize(id, token, encrypted, created)
			@id = id
			@token = token
			@encrypted = encrypted
			@created = created
		end

		private_class_method :new
		
		def self.create(encrypted)
			secret = nil
			begin
				mysql = MysqlConnection.get
				query = %{
					insert into Secret(Encrypted, Created)
					values('#{mysql.escape(encrypted)}', NOW());
				}
				mysql.query(query)
				id = mysql.last_id
				token = SecureRandom.hex(12) + id.to_s
				query = %{
					update Secret
					set Token = '#{mysql.escape(token)}'
					where ID = #{id}
				}
				mysql.query(query)
				query = %{
					select Created 
					from Secret
					where ID = #{id}
				}
				rs = mysql.query(query)
				created = rs.first['Created'] if rs.any?
				secret = new(id, token, encrypted, created)
			ensure
				mysql.close if mysql
			end
			secret
		end

		def self.from_token(token)
			secret = nil
			begin
				mysql = MysqlConnection.get
				query = %{
					select *
					from Secret
					where Token = '#{mysql.escape(token)}';
				}
				rs = mysql.query(query)
				if rs.any?
					row = rs.first
					secret = new(row['ID'], row['Token'], row['Encrypted'], row['Created'])
				end
			ensure
				mysql.close if mysql
			end
			secret
		end

		def self.prune(days = 7)
			return unless days.is_a?(Integer)

			begin
				mysql = MysqlConnection.get
				query = %{
					delete from Secret
					where Created is null or Created < now() - interval #{days.to_i} day;
				}
				mysql.query(query)
			ensure
				mysql.close if mysql
			end
		end
	end	
end
