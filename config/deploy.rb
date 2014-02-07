require 'bundler/capistrano'

set :application, "bunnylove"
set :repository,  "git://github.com/chrismear/bunnylove.git"

set :user, 'chris'
set :deploy_to, "/var/www/bunnylove.org.uk/application"
set :use_sudo, false
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "bunnylove.org.uk"                          # Your HTTP server, Apache/etc
role :app, "bunnylove.org.uk"                          # This may be the same as your `Web` server
role :db,  "bunnylove.org.uk", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update", :link_config

desc "Link in production database config"
task :link_config do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
