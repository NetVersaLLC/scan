require_relative '../spec_helper'
require 'lib/scrappers/citygrid'
require 'awesome_print'

describe 'Citygrid' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Citygrid.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3804 E Chapman Ave Ste F, Orange,  CA 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.citygrid.com/signal-lounge-orange-2"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Citygrid.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end