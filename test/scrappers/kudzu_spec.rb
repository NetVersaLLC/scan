require_relative '../spec_helper'
require 'lib/scrappers/kudzu'
require 'awesome_print'

describe 'Kudzu' do

  it 'should work for listed business' do
    business_data = sample_data(3)
    scrapper = Kudzu.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "902 Masonic Avenue, Albany, CA 94706"
    result['listed_phone'].should == "(510) 526-1109"
    result['listed_url'].should == "http://www.kudzu.com/m/Jodie's-Restaurant-20538227"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Kudzu.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end