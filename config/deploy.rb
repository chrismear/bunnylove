set :application, "bunnylove"
set :repository, "http://mear.dyndns.org/svn/webapps/bunnylove/trunk"

set :deploy_to "/var/www/bunnylove.org.uk/application"

role :web, "toru.odegy.net"
role :app, "toru.odegy.net"
role :db,  "toru.odegy.net", :primary => true

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

after "deploy:update", :link_config

desc "Link in production database config"
task :link_config do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

namespace :deploy do
  namespace :mongrel do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t do
        #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}", :via => run_method 
      end
    end
  end

  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.restart
  end

  desc "Custom start task for mongrel cluster"
  task :start, :roles => :app do
    deploy.mongrel.start
  end

  desc "Custom stop task for mongrel cluster"
  task :stop, :roles => :app do
    deploy.mongrel.stop
  end

end

