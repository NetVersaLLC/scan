ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'sinatra/activerecord'
require 'rack/test'

# adding application base include path
$:.unshift File.dirname(File.dirname(__FILE__))

def sample_data
  {
      "business" => "",
      "phone" => "",
      "zip" => "43652",
      "latitude" => "41.650967",
      "longitude" => "-83.536485",
      "state" => "Ohio",
      "state_short" => "OH",
      "city" => "Toledo",
      "county" => "Lucas",
      "country" => "US"
  }
end

#require 'rack/test'

# set test environment
#Sinatra::Base.set :environment, :test
#Sinatra::Base.set :run, false
#Sinatra::Base.set :raise_errors, true
#Sinatra::Base.set :logging, false

#require File.join(File.dirname(__FILE__), '../application')

