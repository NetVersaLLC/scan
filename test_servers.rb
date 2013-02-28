require 'net/ssh'

File.open('servers.txt').read.split("\n").each do |server|
  Net::SSH.start(server, 'ubuntu', :keys => "#{ENV['HOME']}/Dropbox/NetVersa2.pem") do |ssh|
    output = ssh.exec!("hostname")
    STDERR.puts output
  end
end
