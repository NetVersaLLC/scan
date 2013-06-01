#!/usr/bin/env ruby
require 'active_record'
require './lib/proxy'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => "database.sqlite3"
)

username = 'USfn84YlAPio'
password = 'auxSv8ixd3'
file = ARGV.shift
Proxy.delete_all

File.open(file, "r").each_line do |line|
  host, port = *line.strip.split(":")
  Proxy.create do |proxy|
    proxy.host     = host
    proxy.port     = port
    proxy.username = username
    proxy.password = password
  end
end
