require_relative '../spec_helper'
require 'lib/scrappers/localpages'

describe 'Localpages' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Localpages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.localpages.com/ca/orange/lpd-17146935-signal-lounge.html"
    result['listed_address'].should == "3804 E Chapman Ave Ste F, Orange, CA, 92869"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Localpages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end