require_relative '../spec_helper'
require 'lib/scrappers/gomylocal'
require 'awesome_print'

describe 'Gomylocal' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Gomylocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.gomylocal.com/biz/2838383/Signal-Lounge-Orange-CA-92869"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Gomylocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end