require_relative 'spec_helper'
require 'server'
require 'json'

describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should fail instantly for unknown site' do
    post '/scan.json', :site => "nosuchsite1234", :scan => sample_data
    last_response.should be_ok
    result = JSON.parse last_response.body
    result['error'].should_not eq nil
  end

  it 'should fail instantly when no id provided' do
    data = sample_data
    data['id'] = nil
    post '/scan.json', :site => "Foursquare", :scan => data
    last_response.should be_ok
    result = JSON.parse last_response.body
    result['error'].should_not eq nil
  end


  it 'should say OK and close connection for valid query' do
    data = sample_data
    data['zip'] = 'nosuchzip'
    data['country'] = 'nosuchcountry'
    post '/scan.json', :site => "Foursquare", :scan => sample_data
    last_response.should be_ok
    result = JSON.parse last_response.body
    result['error'].should be_nil
    result['result'].should == 'ok'
  end


  it "says Welcome" do
    get '/'
    last_response.should be_ok
    last_response.body.should eq('Welcome')
  end
end