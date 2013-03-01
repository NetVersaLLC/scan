worker_processes 8
working_directory "/home/ubuntu/app/current"
listen 'unix:/home/ubuntu/app/shared/unicorn.sock', :backlog => 512
timeout 120
pid "/home/ubuntu/app/shared/unicorn.pid"
stderr_path "/home/ubuntu/app/shared/log/unicorn.stderr.log"
stdout_path "/home/ubuntu/app/shared/log/unicorn.stdout.log"

preload_app true
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
