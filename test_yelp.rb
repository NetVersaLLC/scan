#!/usr/bin/env ruby

require 'mechanize'
require 'awesome_print'
require 'activerecord'
require './lib/proxy'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => "database.sqlite3"
)

Proxy.each do |proxy|
  ap proxy
  mech = Mechanize.new
  mech.set_proxy proxy.host, proxy.port, proxy.username, proxy.password
  mech.user_agent_alias = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31'
  mech.get('https://biz.yelp.com/signup')
  ap mech.page.code
  sleep 1
end
