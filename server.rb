require 'sinatra'
require 'json'
require 'watir-webdriver'
require 'headless'
require 'airbrake'

Airbrake.configure do |config|
  config.api_key = '30669d26d752050b00c0b35f52a2f7b2'
  config.host    = 'errors.netversa.com'
  config.port    = 80
  config.secure  = config.port == 443
end

use Airbrake::Sinatra

set :port, 80
set :environment, :production

headless = Headless.new
headless.start
at_exit do
  headless.destroy
end

configure do
  use Rack::Auth::Basic, "login" do |u, p|
    [u,p] == ['api', '13fc9e78f643ab9a2e11a4521479fdfe']
  end
end


get '/' do
  "Welcome"
end

@browser = nil

post '/jobs.json' do
  content_type :json
  data = params['payload_data']
  @data = data
  @chained = true
  errors = nil
  if @browser.nil?
    @browser = Watir::Browser.new
  elsif (rand()*20).to_i == 15
    @browser.close
    @browser = Watir::Browser.new
  end

  begin
	ret,result =  eval(params['payload'])
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
