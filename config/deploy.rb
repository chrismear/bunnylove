# Copyright 2007, 2008, 2009, 2010, 2013 Chris Mear
# 
# This file is part of Bunnylove.
# 
# Bunnylove is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Bunnylove is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with Bunnylove.  If not, see <http://www.gnu.org/licenses/>.

default_run_options[:pty] = true

set :application, "bunnylove"
set :repository, "https://github.com/chrismear/bunnylove.git"
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

