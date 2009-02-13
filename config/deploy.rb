default_run_options[:pty] = true

set :application, "bunnylove"
set :repository, "git@github.com:chrismear/bunnylove.git"
set :scm, "git"
set :user, "chris"
set :checkout, "export"
set :deploy_via, :remote_cache
set :scm_verbose, true
set :branch, "master"

set :deploy_to, "/var/www/bunnylove.org.uk/application"

role :web, "toru.odegy.net"
role :app, "toru.odegy.net"
role :db,  "toru.odegy.net", :primary => true


after "deploy:update", :link_config

desc "Link in production database config"
task :link_config do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

