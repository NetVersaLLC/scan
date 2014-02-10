require_relative '../spec_helper'
require 'lib/scrappers/jayde'

describe 'Jayde' do

  it 'should work for listed business' do
    scrapper = Jayde.new(sample_data(5))
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == "McDonald's"
    result['listed_phone'].should == ''
    result['listed_url'].should == 'http://mcdonalds.co.uk'
    result['listed_address'].should == ''
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(3)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Jayde.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end