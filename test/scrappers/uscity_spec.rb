require_relative '../spec_helper'
require 'lib/scrappers/uscity'
require 'awesome_print'

describe 'Uscity' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Uscity.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E. Chapman Ave., Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://uscity.net/listing/inkling_tattoo_gallery-888888711182"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Uscity.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end