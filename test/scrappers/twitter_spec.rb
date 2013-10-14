require_relative '../spec_helper'
require 'sites/scrappers/twitter'

describe 'Twitter' do

  it 'should work' do
    scrapper = Twitter.new(new_sample_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == "InklingTattooGallery"
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://twitter.com/InklingTattooCA"
    result['listed_address'].should == "Orange, California"
  end

end