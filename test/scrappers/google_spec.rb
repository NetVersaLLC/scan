require_relative '../spec_helper'
require 'lib/scrappers/google'
require 'awesome_print'

describe 'Google' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Google.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == '3904 E Chapman Ave, Orange, CA, United States, 92869'
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "https://plus.google.com/110522586766732861388/about?hl=en-US"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '3453453453'

    scrapper = Google.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end