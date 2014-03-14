require_relative '../spec_helper'
require 'lib/scrappers/merchantcircle'
require 'awesome_print'

describe 'Merchantcircle' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Merchantcircle.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E. Chapman Ave., Orange, CA, 92869"
    result['listed_phone'].should == "714-538-8748"
    result['listed_url'].should == "http://www.merchantcircle.com/business/Inkling.Tattoo.Gallery.714-538-8748"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Merchantcircle.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end