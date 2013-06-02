require 'json'
require 'watir-webdriver'
require 'headless'
require 'airbrake'
require 'rest_client'
require 'nokogiri'
require 'mechanize'
require 'awesome_print'
require 'cgi'
require 'activerecord'
require './lib/proxy'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => "database.sqlite3"
)

headless = Headless.new
headless.start
at_exit do
  headless.destroy
end

site = ARGV.shift
file = __FILE__
parts = file.split("/")
parts.pop
parts.push "./", "sites", site, "SearchListing", "client_script.rb"
file = parts.join("/")
payload = File.read(file).to_s

unless File.exists? file
  return {:error => 'No Listing', :result => result}.to_json
end

data = {
  'zip' => '78734',
  'phone' => '(512) 828-7341',
  'business' => 'Dutch Built'
}

@chained = true
errors = nil

begin
  ap data
  ret,result =  eval(payload)
if ret == true
  errors = {:error => nil, :result => result}
elsif ret == false
  errors = {:error => 'Job failed', :result => result}
else
  errors = {:error => nil, :result => result}
end
rescue => e
  STDERR.puts e.inspect
  STDERR.puts e.backtrace.join("\n")
  errors = {:error => "#{e}: #{e.backtrace.join("\n")}".to_json}
end

puts "Ret: "
ap ret
puts "Result: "
ap result
puts "Errors: "
ap errors
