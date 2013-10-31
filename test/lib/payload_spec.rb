require_relative '../spec_helper'
require 'lib/payload'

describe 'Payload' do

  it 'should do work' do
    scrapper = Payload.new('Foursquare', sample_data(1))
    result = scrapper.execute
    result['status'].should == :claimed
    result['listed_name'].should == "Fifth Third Field"
    result['listed_phone'].should == "(419) 725-4367"
    result['listed_url'].should == "http://foursquare.com/v/fifth-third-field/4b155072f964a52096b023e3"
    result['listed_address'].should == "406 Washington St, ToledoOH, 43604-1046"
  end

end