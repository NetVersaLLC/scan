class Proxy
  attr_accessor :host, :port, :username, :password
  def initialize(host, port)
    @host     = host
    @port     = port
    @username = 'USfn84YlAPio'
    @password = 'auxSv8ixd3'
  end
  def self.get
    unless @proxies
      file  = __FILE__.split("/")
      file.pop
      file.pop
      file.push 'proxies.txt'
      @proxies = IO.readlines(file.join("/"))
    end
    proxy = @proxies[ rand( @proxies.length  ) ].strip
    username, password = *proxy.split(":")
    return Proxy.new( username, password )
  end
  def self.mechanize
    proxy = self.get
    mech = Mechanize.new
    mech.set_proxy proxy.host, proxy.port, proxy.username, proxy.password
    mech
  end
  def self.restclient
    proxy = self.get
    RestClient.proxy = "http://#{proxy.username}:#{proxy.password}@#{proxy.host}:#{proxy.port}"
  end
end

