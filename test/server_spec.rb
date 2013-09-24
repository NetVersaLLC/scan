require_relative 'spec_helper'
require 'server'
require 'json'

describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should fail instantly for unknown site' do
    post '/scan.json', :site => "nosuchsite1234", :data => sample_data
    #response = last_response
    last_response.should be_ok
    result = JSON.parse last_response.body
    result['error'].should_not eq nil
  end

  it "says Welcome" do
    get '/'
    last_response.should be_ok
    last_response.body.should eq('Welcome')
  end
end