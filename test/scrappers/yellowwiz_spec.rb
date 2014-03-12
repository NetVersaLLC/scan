require_relative '../spec_helper'
require 'lib/scrappers/yellowwiz'
require 'awesome_print'

describe 'Yellowwiz' do

  it 'should work for listed business' do
    business_data = sample_data(10)
    scrapper = Yellowwiz.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == business_data['address']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.yellowwiz.com/USA/California/Orange/Artists+-+Fine+Arts/fine-art-gallery_10422387"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Yellowwiz.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end