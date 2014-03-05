require_relative '../spec_helper'
require 'lib/scrappers/bing'

describe 'Bing' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Bing.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.bing.com/local/Details.aspx?lid=YN102x401982386"
    result['listed_address'].should == '3904 E Chapman Ave, Orange, CA 92869'
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Bing.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end