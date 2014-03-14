require_relative '../spec_helper'
require 'lib/scrappers/manta'
require 'awesome_print'

describe 'Manta' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Manta.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 East Chapman Avenue, Orange, CA, 92869"
    result['listed_phone'].should == "7145388748"
    result['listed_url'].should == "http://www.manta.com/c/mx0vtdb/inkling-tattoo-gallery"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Manta.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end