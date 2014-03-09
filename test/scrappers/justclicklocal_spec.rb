require_relative '../spec_helper'
require 'lib/scrappers/justclicklocal'
require 'awesome_print'

describe 'Justclicklocal' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Justclicklocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA"
    result['listed_phone'].should == "714-538-8748"
    result['listed_url'].should == ""
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Justclicklocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end