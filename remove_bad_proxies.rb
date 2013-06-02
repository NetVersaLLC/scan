#!/usr/bin/env ruby

require 'mechanize'
require 'awesome_print'
require 'active_record'
require './lib/proxy'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => "database.sqlite3"
)

Proxy.all.each do |proxy|
  mech = Mechanize.new
  mech.set_proxy proxy.host, proxy.port, proxy.username, proxy.password
  mech.user_agent_alias = 'Mac FireFox'
  begin
    mech.get('https://biz.yelp.com/signup')
  rescue Mechanize::ResponseCodeError
    STDERR.puts "Proxy is bad: #{proxy.inspect}"
    proxy.delete
    next
  end
  unless mech.page.code == 200
    STDERR.puts "Proxy is weird: #{proxy.inspect}"
  else
    STDERR.puts "Proxy is good: #{proxy.inspect}"
  end
  sleep 1
end
