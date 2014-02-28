require_relative '../spec_helper'
require 'lib/scrappers/expressbusinessdirectory'
require 'awesome_print'

describe 'Expressbusinessdirectory' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Expressbusinessdirectory.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 East Chapman Avenue, Orange, California, 92869, United States"
    result['listed_phone'].should == "714-538-8748"
    result['listed_url'].should == "http://www.expressbusinessdirectory.com/Companies/Inkling-Tattoo-Gallery-C34944"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(1)
    scrapper = Expressbusinessdirectory.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end