require_relative '../spec_helper'
require 'lib/scrappers/fyple'
require 'awesome_print'

describe 'Fyple' do

  it 'should work for listed business' do
    business_data = sample_data(8)
    scrapper = Fyple.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "4511 Willow Road #8, Pleasanton, CA 94588"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.fyple.com/company/adt-security-services-vze1qm/"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Fyple.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end