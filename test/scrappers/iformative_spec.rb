require_relative '../spec_helper'
require 'lib/scrappers/iformative'
require 'awesome_print'

describe 'Iformative' do

  it 'should work for listed business' do
    business_data = sample_data(7)
    scrapper = Iformative.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "E. Market, Howland, Ohio, United States"
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://www.iformative.com/product/burger-king-p276.html"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Iformative.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end