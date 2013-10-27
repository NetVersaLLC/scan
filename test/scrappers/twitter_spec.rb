require_relative '../spec_helper'
require 'lib/scrappers/twitter'

describe 'Twitter' do

  it 'should work' do
    scrapper = Twitter.new(sample_data(0))
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == "InklingTattooGallery"
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://twitter.com/InklingTattooCA"
    result['listed_address'].should == "Orange, California"
  end

end