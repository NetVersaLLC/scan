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

require 'sites/scrappers/abstract_scrapper'

# loading environment-specific settings
all_settings = Psych.load(File.read(application_path + '/application.yml'))
$settings = all_settings[Sinatra::Base.settings.environment.to_s]


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

def sample_claimed_business_data
  {
      "business" => "Inkling Tattoo Gallery",
      "phone" => "(714) 538-8748",
      "zip" => "92869",
      "latitude" => "33.6209850000",
      "longitude" => "-117.9321100000",
      "state" => "California",
      "state_short" => "CA",
      "city" => "Orange",
      "county" => "Orange",
      "country" => "US"
  }
end

def sample_unclaimed_business_data
  {
      "business" => "Signal Lounge",
      "phone" => "(714) 532-9035",
      "zip" => "92869",
      "latitude" => "33.6209850000",
      "longitude" => "-117.9321100000",
      "state" => "California",
      "state_short" => "CA",
      "city" => "Orange",
      "county" => "Orange",
      "country" => "US"
  }
end

# set test environment
Sinatra::Base.set :environment, :test

