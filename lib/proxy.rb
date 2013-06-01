class Proxy < ActiveRecord::Base
  def self.get
    Proxy.first(:order => "RANDOM()")
  end
  def self.mechanize
    proxy = self.get
    mech = Mechanize.new
    mech.set_proxy proxy.host, proxy.port, proxy.username, proxy.password
  end
  def self.restclient
    proxy = self.get
    RestClient.proxy "http://#{proxy.username}:#{proxy.password}@#{proxy.host}:#{proxy.port}"
  end
end

