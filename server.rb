require 'sinatra'
require 'json'
require 'airbrake'
require 'awesome_print'
require 'active_record'
require 'sinatra/activerecord'
require 'lib/scanner'

set :database, 'sqlite://database.sqlite3'

Airbrake.configure do |config|
  config.api_key = '671bbb8cee606d1241528e892b853d69'
  config.host    = 'errors.netversa.com'
  config.port = 80
  config.secure = config.port == 443
end
use Airbrake::Sinatra

get '/' do
  "Welcome"
end

post '/scan.json' do
  content_type :json
  site = params[:site]

  data = {}

  begin
    scanner = Scanner.new(site, data)
    scanner.scan.to_json
  rescue e => e
    return {:error => e}.to_json
  end
end

get '/ping' do
  "pong"
end
