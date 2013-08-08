require 'sinatra'
require 'json'
require 'airbrake'
require 'rest_client'
require 'nokogiri'
require 'mechanize'
require 'awesome_print'
require 'active_record'
require 'sinatra/activerecord'
require './lib/proxy'

set :database, 'sqlite://database.sqlite3'

Airbrake.configure do |config|
  config.api_key = '671bbb8cee606d1241528e892b853d69'
  config.host    = 'errors.netversa.com'
  config.port    = 80
  config.secure  = config.port == 443
end
use Airbrake::Sinatra

get '/' do
  "Welcome"
end

post '/scan.json' do
  content_type :json
  site = params[:site]

  file = __FILE__
  parts = file.split("/")
  parts.pop
  parts.push "sites", site, "SearchListing", "client_script.rb"
  file = parts.join("/")
  payload = File.open( file, "r" ).read

  unless File.exists? file
    return {:error => 'No Listing', :result => result}.to_json
  end

  data = {}
  if params[:payload_data]
    data = JSON.parse( params[:payload_data] )
  end

  @chained = true
  errors = nil

  begin
    ap data
	ret,result =  eval(payload)
	if ret == true
		errors = {:error => nil, :result => result}
	elsif ret == false
		errors = {:error => 'Job failed', :result => result}
	else
		errors = {:error => nil, :result => result}
	end
  rescue => e
    errors = {:error => "#{e}: #{e.backtrace.join("\n")}".to_json}
  end
  STDERR.puts errors.to_json
  errors.to_json
end

get '/ping' do
  "pong"
end
