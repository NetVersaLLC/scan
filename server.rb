require 'sinatra'
require 'json'
require 'airbrake'
require 'awesome_print'
require 'active_record'
require 'sinatra/activerecord'


# adding application base include path
application_path = File.dirname(__FILE__)
$:.unshift application_path

# loading environment-specific settings
all_settings = Psych.load(File.read(application_path + '/application.yml'))
$settings = all_settings[ENV['RACK_ENV']]

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
  data = params[:scan]
  if data['id'].nil?
    return {:error => 'No scan id provided'}.to_json
  end

  begin
    scanner = Scanner.new(site, data)
  rescue => e
    return {:error => e.to_s}.to_json
  end
  th = Thread.new(scanner) { |scanner|
    begin
      scanner.scan
    rescue => e
      puts "thread died with exception: " + e.to_s
    end
  }
  th.join
  {:error => nil, :result => 'ok'}.to_json
end

