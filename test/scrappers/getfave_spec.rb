require_relative '../spec_helper'
require 'lib/scrappers/getfave'
require 'awesome_print'

describe 'Getfave' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Getfave.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E. Chapman Ave., Orange, CA 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "https://www.getfave.com/19406879-inkling-tattoo-gallery"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(1)
    scrapper = Getfave.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end