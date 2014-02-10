require_relative '../spec_helper'
require 'lib/scrappers/zippro'

describe 'Zippro' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Zippro.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://92869.zip.pro/profiles/Inkling-Tattoo-Gallery_25680007"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Zippro.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

  it 'should work for "Signal Lounge" business' do
    business_data = sample_data(2)
    scrapper = Zippro.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://92869.zip.pro/profiles/Signal-Lounge_2797809"
    result['listed_address'].should == "3804 E Chapman Ave, Ste F, Orange, CA, 92869"
  end

end