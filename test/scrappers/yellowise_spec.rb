require_relative '../spec_helper'
require 'lib/scrappers/yellowise'

describe 'Yellowise' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Yellowise.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.yellowise.com/business/Orange-CA/Inkling-Tattoo-Gallery/Inkling-Tattoo-Gallery/1532490-ST6?&ids=1205249"
    result['listed_address'].should == "3904 E. Chapman Ave., Orange, CA 92869"
  end

  it 'should not fail for unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Yellowise.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end