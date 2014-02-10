require_relative '../spec_helper'
require 'lib/scrappers/hotfrog'
require 'awesome_print'

describe 'Hotfrog' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Hotfrog.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == '7145388748'
    result['listed_url'].should == "http://www.hotfrog.com/Companies/Inkling-Tattoo-Gallery"
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869-3915"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Hotfrog.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

  it 'should not fail when single quot in query' do
    business_data = sample_data(4)
    scrapper = Hotfrog.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
  end


end