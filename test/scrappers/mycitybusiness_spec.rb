require_relative '../spec_helper'
require 'lib/scrappers/mycitybusiness'

describe 'Mycitybusiness' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Mycitybusiness.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == "Inkling Tattoo Gallery"
    result['listed_phone'].should == "714-538-8748"
    result['listed_url'].should == ""
    result['listed_address'].should == "3904 E. Chapman Avenue, Orange, CA 92869"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'
    business_data['city'] = 'noname city'
    business_data['state_short'] = 'noname state_short'

    scrapper = Mycitybusiness.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end