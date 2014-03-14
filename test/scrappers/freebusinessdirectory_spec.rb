require_relative '../spec_helper'
require 'lib/scrappers/freebusinessdirectory'
require 'awesome_print'

describe 'Freebusinessdirectory' do

  it 'should work for listed business' do
    business_data = sample_data(13)
    scrapper = Freebusinessdirectory.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == business_data['address']
    result['listed_phone'].should == business_data['phone']
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Freebusinessdirectory.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end