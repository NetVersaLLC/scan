require_relative '../spec_helper'
require 'lib/scrappers/insiderpages'
require 'awesome_print'

describe 'Insiderpages' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Insiderpages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3804 E Chapman Ave Ste F, Orange, CA, 92869"
    result['listed_phone'].should == "714-532-9035"
    result['listed_url'].should == "http://www.insiderpages.com/b/3711288322/signal-lounge-orange"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Insiderpages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end