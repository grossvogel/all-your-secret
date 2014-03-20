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
				db = DBConnection.get
				query = %{
					insert into secret(encrypted, created)
					values('#{db.escape(encrypted)}', NOW());
				}
				db.query(query)
				id = db.last_id('Secret')
				token = SecureRandom.hex(12) + id.to_s
				query = %{
					update secret
					set token = '#{db.escape(token)}'
					where id = #{id}
				}
				db.query(query)
				query = %{
					select created 
					from secret
					where id = #{id}
				}
				created = nil
				db.query(query) do |record|
					puts record.inspect
					created = record['created']
				end
				secret = new(id, token, encrypted, created)
			ensure
				db.close if db 
			end
			secret
		end

		def self.from_token(token)
			secret = nil
			begin
				db = DBConnection.get
				query = %{
					select *
					from secret
					where token = '#{db.escape(token)}';
				}
				db.query(query) do |record|
					secret = new(record['id'], record['token'], record['encrypted'], record['created'])
				end
			ensure
				db.close if db
			end
			secret
		end

		def self.prune(days = 7)
			return unless days.is_a?(Integer)

			begin
				db = DBConnection.get
				query = %{
					delete from secret
					where created is null or created < now() - interval '#{days.to_i} day';
				}
				db.query(query)
			ensure
				db.close if db
			end
		end
	end	
end
