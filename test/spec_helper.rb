ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'psych'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'rack/test'

# adding application base include path
application_path = File.dirname(File.dirname(__FILE__))
$:.unshift application_path

# loading environment-specific settings
all_settings = Psych.load(File.read(application_path + '/application.yml'))
$settings = all_settings[ENV['RACK_ENV']]


def sample_data
  {
      "id" => '123',
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
Sinatra::Base.set :environment, :test
#Sinatra::Base.set :run, false
#Sinatra::Base.set :raise_errors, true
#Sinatra::Base.set :logging, false

#require File.join(File.dirname(__FILE__), '../application')

