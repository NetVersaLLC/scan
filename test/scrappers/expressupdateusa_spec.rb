require_relative '../spec_helper'
require 'lib/scrappers/expressupdateusa'
require 'awesome_print'

describe 'Expressupdateusa' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Expressupdateusa.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.expressupdate.com/places/VVZT3BSP"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Expressupdateusa.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end