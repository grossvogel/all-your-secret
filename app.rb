#
#	Main application script
#

require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra'

def load_libraries
	$: << File.expand_path(File.dirname(__FILE__))
	require 'lib/config'
	$config[:libraries].each do |dir|
		Dir["#{dir}/*.rb"].each { |file| require file }
	end
end
load_libraries


class App < Sinatra::Base
	enable :sessions

	configure :development do
		enable :logging
	end

	before  '/*' do
		@title = 'All Your Secret'
	end

	get '/' do
		Model::Secret.prune($config[:secret_expiration_days])
		erb :index
	end

	post '/secrets' do
		encrypted = params[:encrypted_secret]
		secret = Model::Secret.create(encrypted)
		content_type :json
		url = absolute_link("/secrets/#{secret.token}") unless secret.nil?
		{ :url => url }.to_json
	end

	get '/secrets/:token' do
		token = params[:token]
		secret = Model::Secret.from_token(token)
		if secret.nil?
			erb :file_not_found
		else
			@encrypted_secret = secret.encrypted
			erb :secret
		end
	end

	error 404 do
		erb :file_not_found
	end

	#	HELPERS
	helpers do
		def h(text)
			Rack::Utils.escape_html text
		end

		def absolute_link(rel)
			request.scheme + '://' + request.host_with_port + rel
		end
	end

	run! if app_file == $0
end

