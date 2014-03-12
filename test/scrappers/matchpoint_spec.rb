require_relative '../spec_helper'
require 'lib/scrappers/matchpoint'
require 'awesome_print'

describe 'Matchpoint' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Matchpoint.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3804 Chapman Ave, Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.matchpoint.com/business/Orange/CA/Signal-Lounge/hbefdcjadf"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Matchpoint.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end