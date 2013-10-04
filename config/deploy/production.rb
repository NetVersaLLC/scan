set :branch, 'master'
set :rails_env, :production
set :domain, File.open('servers.txt').read.split("\n")

role :web, *domain
role :app, *domain
role :db,  *domain, :primary => true