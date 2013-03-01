require 'net/ssh'

File.open('servers.txt').read.split("\n").each do |server|
  STDERR.puts "Connecting to: #{server}"
  Net::SSH.start(server, 'ubuntu', :keys => "#{ENV['HOME']}/Dropbox/NetVersa2.pem") do |ssh|
    output = ssh.exec!("hostname")
    STDERR.puts output
  end
end
