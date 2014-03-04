require_relative '../spec_helper'
require 'lib/scrappers/facebook'
require 'awesome_print'

describe 'Facebook' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Facebook.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_url'].should == "https://www.facebook.com/inklingtattoogallery"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(2)
    scrapper = Facebook.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end
