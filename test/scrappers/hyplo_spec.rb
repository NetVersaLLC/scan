require_relative '../spec_helper'
require 'lib/scrappers/hyplo'
require 'awesome_print'

describe 'Hyplo' do

  it 'should work for listed business' do
    business_data = sample_data(15)
    scrapper = Hyplo.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == business_data['address']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.hyplo.com/site/110195/Anaheim-California"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Hyplo.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end