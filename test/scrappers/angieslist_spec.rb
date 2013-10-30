require_relative '../spec_helper'
require 'lib/scrappers/angieslist'
require 'awesome_print'

describe 'Angieslist' do

  it 'should work for lsited business' do
    business_data = sample_data(4)
    scrapper = Angieslist.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == '106 31st Street, Newport Beach, CA'
    result['listed_phone'].should == ''
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(3)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Angieslist.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end