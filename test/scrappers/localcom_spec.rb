require_relative '../spec_helper'
require 'lib/scrappers/localcom'
require 'awesome_print'

describe 'Localcom' do

  it 'should work for listed business' do
    business_data = sample_data(3)
    scrapper = Localcom.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "902 Masonic Ave, Albany, CA, 94706"
    result['listed_phone'].should == "(510) 526-1109"
    result['listed_url'].should == "http://www.local.com/business/details/albany-ca/jodies-restaurant-12187888/"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Localcom.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end