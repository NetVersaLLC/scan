require_relative '../spec_helper'
require 'lib/scrappers/zippro'

describe 'Zippro' do

  it 'should work for listed business' do
    business_data = sample_data(3)
    scrapper = Zippro.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "902 Masonic Ave, Albany, CA, 94706"
    result['listed_phone'].should == "(510) 526-1109"
    result['listed_url'].should == "http://94706.zip.pro/profiles/Jodies-Restaurant_13051752"
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

end
