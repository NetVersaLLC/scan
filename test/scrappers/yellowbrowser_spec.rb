require_relative '../spec_helper'
require 'lib/scrappers/yellowbrowser'
require 'awesome_print'

describe 'Yellowbrowser' do

  it 'should work for listed business' do
    business_data = sample_data(10)
    scrapper = Yellowbrowser.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "1623 W Katella Ave, Orange, CA 92867"
    result['listed_phone'].should == "7145324498"
    result['listed_url'].should == "http://www.yellowbrowser.com/Local/California/Orange/Artists+-+Fine+Arts/fine-art-gallery_10422387"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Yellowbrowser.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end