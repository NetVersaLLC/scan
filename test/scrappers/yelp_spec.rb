require_relative '../spec_helper'
require 'lib/scrappers/yelp'

describe 'Yelp' do

  it 'should work for claimed business' do
    scrapper = Yelp.new(sample_data(0))
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == "Inkling Tattoo Gallery"
    result['listed_phone'].should == "(714) 538-8748"
    result['listed_url'].should == "http://www.yelp.com/biz/inkling-tattoo-gallery-orange-2"
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869"
  end

  it 'should work for unclaimed business' do
    scrapper = Yelp.new(sample_data(2))
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == "Signal Lounge"
    result['listed_phone'].should == "(714) 532-9035"
    result['listed_url'].should == "http://www.yelp.com/biz/signal-lounge-orange"
    result['listed_address'].should == "3804 E Chapman Ave, Ste F, Orange, CA, 92869"
  end

end