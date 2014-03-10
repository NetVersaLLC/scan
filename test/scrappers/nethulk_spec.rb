require_relative '../spec_helper'
require 'lib/scrappers/nethulk'
require 'awesome_print'

describe 'Nethulk' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Nethulk.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3804 East Chapman Avenue Suite F, Orange, CA, 92869"
    result['listed_phone'].should == "714-532-9035"
    result['listed_url'].should == "www.nethulk.com/signal-lounge/business-ca-815566/"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Nethulk.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end