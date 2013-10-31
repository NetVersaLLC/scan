require_relative '../spec_helper'
require 'lib/scrappers/thumbtack'

describe 'Thumbtack' do

  it 'should work for listed business' do
    business_data = {
        'business' => 'Window & Blind Cleaning',
        'zip' => '92869'
    }
    scrapper = Thumbtack.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_url'].should == "http://www.thumbtack.com/ca/fullerton/carpet-cleaning/window-and-blind-cleaning"
    result['listed_address'].should == "Fullerton, CA 92832"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Thumbtack.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end