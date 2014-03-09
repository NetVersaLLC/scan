require_relative '../spec_helper'
require 'lib/scrappers/cornerstonesworld'
require 'awesome_print'

describe 'Cornerstonesworld' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Cornerstonesworld.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 East Chapman Avenue, 92869 Orange California"
    result['listed_phone'].should == "714-538-8748"
    result['listed_url'].should == "http://www.cornerstonesworld.com/en/directory/country/USA/state/CA/keyword/Inkling+Tattoo+Gallery/new"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(1)
    scrapper = Cornerstonesworld.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end