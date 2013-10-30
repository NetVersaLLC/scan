require_relative '../spec_helper'
require 'lib/scrappers/mycitybusiness'

describe 'Mycitybusiness' do

  it 'should work for unlisted business' do
    business_data = sample_data(0)
    scrapper = Mycitybusiness.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == "nate marlowe"
    result['listed_phone'].should == "714-538-8748"
    result['listed_url'].should == "http://www.facebook.com/inklingtattoogallery"
    result['listed_address'].should == "3904 East Chapman Avenue,Orange, CA 92869"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Mycitybusiness.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end