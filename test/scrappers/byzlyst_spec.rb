require_relative '../spec_helper'
require 'lib/scrappers/byzlyst'
require 'awesome_print'

describe 'Byzlyst' do

  it 'should work for listed business' do
    business_data = sample_data(12)
    scrapper = Byzlyst.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == ""
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://byzlyst.com/pinnacle-homes/"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Byzlyst.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end