require_relative '../spec_helper'
require 'lib/scrappers/bizzspot'
require 'awesome_print'

describe 'Bizzspot' do

  it 'should work for listed business' do
    business_data = sample_data(12)
    scrapper = Bizzspot.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == business_data['address']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.bizzspot.com/Home-Builder-in-Northville-MI-Pinnacle-Homes-9460"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Bizzspot.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end