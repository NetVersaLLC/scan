require_relative '../spec_helper'
require 'lib/payload'
require 'awesome_print'

describe 'Payload' do

  it 'should do work' do
    scrapper = Payload.new('Foursquare', sample_data(0))
    result = scrapper.execute
    expected_data = sample_data(0)
    result['status'].should == :claimed
    result['listed_name'].should == expected_data['business']
    result['listed_url'].should == "http://foursquare.com/v/inkling-tattoo-gallery/4f6a372ae4b068b1a70520d3"
    result['listed_address'].should == "3904 E Chapman Ave, OrangeCA, 92869"
  end

end