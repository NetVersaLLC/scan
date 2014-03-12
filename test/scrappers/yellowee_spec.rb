require_relative '../spec_helper'
require 'lib/scrappers/yellowee'
require 'awesome_print'

describe 'Yellowee' do

  it 'should work for listed business' do
    business_data = sample_data(11)
    scrapper = Yellowee.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == business_data['address']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.yellowee.com/b/protect-you-home-adt-authorized-dealer-orange-ca-93809879"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Yellowee.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end
