require_relative '../spec_helper'
require 'lib/scrappers/adsolutionsyp'
require 'awesome_print'

describe 'Adsolutionsyp' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Adsolutionsyp.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.yellowpages.com/orange-ca/mip/inkling-tattoo-gallery-467180796?lid=467180796"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Adsolutionsyp.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end