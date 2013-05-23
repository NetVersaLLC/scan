require 'sinatra'

set :env,  :production
disable :run

require './server.rb'

app = Rack::Auth::Digest::MD5.new(Sinatra::Application) do |username|
    { 'api' => '13fc9e78f643ab9a2e11a4521479fdfe' }[username]
end

app.realm = 'Protected Area'
app.opaque = 'secretkey'

run app
