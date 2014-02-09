require_relative '../spec_helper'
require 'lib/scrappers/twitter'

describe 'Twitter' do

  it 'should work' do
    scrapper = Twitter.new(sample_data(5))
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == "McDonald's"
    result['listed_address'].should == ""
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://twitter.com/McDonalds"
  end

end