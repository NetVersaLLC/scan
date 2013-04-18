require 'spec_helper'

# require 'server'
# require 'rspec'
# require 'rack/test'

describe 'Sinatra App' do

  context 'GET root url' do 
    it 'should be successful' do 
      get '/'
      last_response.should be_ok
      last_response.body.should == 'Welcome'
    end
  end

  context 'GET /ping' do
    it 'should be successful' do 
      get '/ping'
      last_response.should be_ok
      last_response.body.should == 'pong'
    end
  end

  context 'POST /jobs.json' do 
    context 'no payload should fail' do 
      xit 'test' 
    end

    context 'payload without sites scirpts should fail' do 
      xit 'test'
    end

    context 'payload with sites scirpts' do 
      xit 'tests'
    end
  end

end