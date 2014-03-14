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
    5 => {
        "business" => "McDonald's"
    },
    6 => {
        "business" => "University of West Florida"
    },
    7 => {
        "business" => "Burger King",
        "zip" => "26003"
    },
    8 => {
        "business" => "ADT Security Services",
        "phone" => "(866) 285-8345",
        "address" => "4511 Willow Road #8, Pleasanton, CA 94588",
        "zip" => "94588",
        "state" => "California",
        "state_short" => "CA",
        "city" => "Pleasanton",
        "county" => "Alameda",
        "country" => "US"
    },
    9 => {
        "business" => "Green Pea Salon",
        "zip" => "37204"
    },
    10 => {
        "business" => "Fine Art Gallery",
        "phone" => "714-532-4498",
        "address" => "1623 W Katella Ave, Orange CA 92867",
        "zip" => "92867",
        "state" => "California",
        "state_short" => "CA",
        "city" => "Orange"
    },
    11 => {
        "business" => "Protect You Home - Adt Authorized Dealer",
        "phone" => "(714) 464-6896",
        "address" => "1815 E. Heim Ave., Orange, CA, 92865",
        "zip" => "92865",
        "state" => "California",
        "state_short" => "CA",
        "city" => "Orange"
    },
    12 => {
        "business" => "Pinnacle Homes",
        "phone" => "(248) 449-4000",
        "address" => "52014 Carrington, Northville, MI, 48167",
        "zip" => "48167",
        "state" => "Michigan",
        "state_short" => "MI",
        "city" => "Northville"
    },
    13 => {
        "business" => "Cavatore Italian Restaurant",
        "phone" => "713-8696622",
        "address" => "2120 Ella Boulevard, Houston, TX 77008",
        "zip" => "77008",
        "state_short" => "TX",
        "city" => "Houston"
    },
    14 => {
        "business" => "Locksmith Placentia",
        "phone" => "(714) 783-1139",
        "address" => "919 Santiago Drive 1137, Placentia, CA 92870",
        "zip" => "92870",
        "state_short" => "CA",
        "city" => "Placentia"
    },
    15 => {
        "business" => "Connect Plumbing",
        "phone" => "",
        "address" => "Anaheim, CA 92805",
        "zip" => "92805",
        "state_short" => "CA",
        "city" => "Anaheim"
    },
    16 => {
        "business" => "The Pub Orlando",
        "phone" => "+1 (407) 352-2305",
        "address" => "9101 International Dr., Orlando, FL, 32819",
        "zip" => "32819",
        "state_short" => "FL",
        "city" => "Orlando"
    }
}

def sample_data(id)
  $business_data[id]
end

# set test environment
Sinatra::Base.set :environment, :test
