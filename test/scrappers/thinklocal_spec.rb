require_relative '../spec_helper'
require 'lib/scrappers/thinklocal'
require 'awesome_print'

describe 'Thinklocal' do

  it 'should work for listed business' do
    business_data = sample_data(14)
    scrapper = Thinklocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == business_data['address']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.thinklocal.com/LocksmithPlacentia-18122759.html"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Thinklocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end