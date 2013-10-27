require_relative '../spec_helper'
require 'lib/scrappers/bing'

describe 'Bing' do

  it 'should work for lsited business' do
    business_data = sample_data(3)
    scrapper = Bing.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.bing.com/local/details.aspx?lid=YN120x2219160&qt=yp&what=%22(510)+526-1109%22&where=&s_cid=ansPhBkYp02&mkt=en-US&q=%22(510)+526-1109%22&FORM=MONITR"
    result['listed_address'].should == business_data['address']
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(3)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Bing.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end