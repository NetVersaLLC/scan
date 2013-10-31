require_relative '../spec_helper'
require 'lib/scrappers/ibegin'
require 'awesome_print'

describe 'Ibegin' do

  it 'should work for lsited business' do
    business_data = sample_data(3)
    scrapper = Ibegin.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.ibegin.com/directory/us/california/albany/jodies-restaurant/"
    result['listed_address'].should == "902 Masonic Ave, Albany, California 94706"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(3)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Ibegin.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

  it 'should return unlisted for broken page' do
    business_data = sample_data(4)
    scrapper = Ibegin.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end