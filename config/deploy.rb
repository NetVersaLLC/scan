require 'bundler/capistrano'

set :domain, File.open('servers.txt').read.split("\n")
set :application, "scanner"
set :deploy_to, "/home/ubuntu/app"
set :user, "ubuntu"
set :use_sudo, false
set :ssh_options, { :keys => ["#{ENV['HOME']}/Dropbox/new_keys/deploy/scan"] }
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/unicorn.pid"

set :default_shell, "bash -l"
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

set :use_sudo   , false
# set :ssh_options, {:forward_agent => true}

# default_run_options[:shell] = 'bash -l'
set :scm, :git
set :repository,  "git@github.com:NetVersaLLC/scan.git"
set :branch, 'master'
set :git_shallow_clone, 1
set :rails_env, :production

role :web, *domain
role :app, *domain
role :db,  *domain, :primary => true

# set :deploy_via, "remote_cache"

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then sudo service unicorn restart; else sudo service unicorn start; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && sudo service unicorn start"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then sudo service unicorn stop; fi"
  end
end
