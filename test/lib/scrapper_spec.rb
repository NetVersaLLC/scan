require_relative '../spec_helper'
require 'sites/scrappers/abstract_scrapper.rb'
require 'sites/scrappers/yelp.rb'


describe 'Scrapper' do

  it 'should return valid results' do
    scrapper = Yelp.new(new_sample_data)
    result = scrapper.execute
    result['status'].should == :claimed
    result['listed_name'].should == "Fifth Third Field"
    result['listed_phone'].should == "(419) 725-4367"
    result['listed_url'].should == "https://foursquare.com/v/fifth-third-field/4b155072f964a52096b023e3"
    result['listed_address'].should == "406 Washington St, ToledoOH, 43604-1046"
  end

end