ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'psych'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'rack/test'
require 'watir-webdriver'
require 'headless'

# adding application base include path
application_path = File.dirname(File.dirname(__FILE__))
$:.unshift application_path

require 'lib/scrappers/abstract_scrapper'

# loading environment-specific settings
all_settings = Psych.load(File.read(application_path + '/application.yml'))
$settings = all_settings[Sinatra::Base.settings.environment.to_s]

$business_data = {
    0 => {
        "id" => '123',
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
    },
    1 => {
        "id" => '123',
        "business" => "Connect Your Home",
        "phone" => "(866) 308-3285",
        "zip" => "92705",
        "latitude" => "33.6209850000",
        "longitude" => "-117.9321100000",
        "state" => "California",
        "state_short" => "CA",
        "city" => "Orange",
        "county" => "Orange",
        "country" => "US"
    },
    2 => {
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
    },
    3 => {
        "business" => "Jodie's Restaurant",
        "phone" => "510-526-1109",
        "address" => "902 Masonic Ave Albany, CA 94706",
        "zip" => "94706",
        "latitude" => "33.6209850000",
        "longitude" => "-117.9321100000",
        "state" => "California",
        "state_short" => "CA",
        "city" => "Orange",
        "county" => "Orange",
        "country" => "US"
    },
    4 => {
        "business" => "Crystal's Bakery",
        "phone" => "949-287-3810",
        "address" => "106 31st Street, Newport Beach, California 92663",
        "zip" => "92663",
        "latitude" => "33.6209850000",
        "longitude" => "-117.9321100000",
        "state" => "California",
        "state_short" => "CA",
        "city" => "Newport Beach",
        "county" => "Orange",
        "country" => "US"
    },
}

def sample_data(id)
  $business_data[id]
end

# set test environment
Sinatra::Base.set :environment, :test

