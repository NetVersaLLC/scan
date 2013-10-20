require 'sinatra'
require 'json'
require 'airbrake'
require 'awesome_print'
require 'active_record'
require 'sinatra/activerecord'
require 'carmen'

# adding application base include path
application_path = File.dirname(__FILE__)
$:.unshift application_path


# loading environment-specific settings
all_settings = Psych.load(File.read(application_path + '/application.yml'))
$settings = all_settings[Sinatra::Base.settings.environment.to_s]

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

# test single scrapper without threading and callbacks - form
get '/scrappertest' do
  erb :'scrappertest'
end

# test single scrapper without threading and callbacks - handler
post '/scrappertest' do
  require 'lib/location'
  location = Location.where(:zip => params[:zip]).first
  data = {}
  data['zip'] = params[:zip]
  data['business'] = params[:business]
  data['phone'] = params[:phone]
  data['id'] = 1
  data['latitude'] = location.latitude
  data['longitude'] = location.longitude
  data['state_short'] = location.state
  data['city'] = location.city
  data['county'] = location.county
  data['country'] = location.country
  data['state'] = Carmen::state_name(location.state)

  begin
    scanner = Scanner.new(params[:site], data)
    result = scanner.scan(true) # true means skip callback
  rescue => e
    puts "scanner died with exception: #{e}: #{e.backtrace.join("\n")}"
  end
  result.to_json
end

post '/scan.json' do
  content_type :json

  site = params[:site]
  data = params[:scan]
  if data['id'].nil?
    return {:error => 'No scan id provided'}.to_json
  end

  begin
    scanner = Scanner.new(site, data, params[:callback_host], params[:callback_port])
  rescue => e
    return {:error => e.to_s}.to_json
  end
  Thread.new(scanner) { |t|
    begin
      t.scan
    rescue => e
      puts "thread died with exception: #{e}: #{e.backtrace.join("\n")}"
    end
  }
  {:error => nil, :result => 'ok'}.to_json
end

