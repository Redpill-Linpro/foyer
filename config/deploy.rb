# Copyright 2011 Redpill-Linpro AS.
#
# This file is part of Foyer.
#
# Foyer is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Foyer is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Foyer. If not, see <http://www.gnu.org/licenses/>.

# Support deploying to different environments.
require 'capistrano/ext/multistage'

# Use bundler during deployment.
require "bundler/capistrano"

set :stages, %w{staging production}
#set :default_stage, :staging

# Please see the config/deploy directory for deployment scripts for the
# different environments.

# Name of application:
set :application, "foyer"

# Where to checkout the source from:
set :local_repository, "git@your-repo.example.com"

# Where to temporarily place the source both locally and on the server:
set :repository,       "/tmp/foyer.git"
set :scm, :git

# Override deploy:{start,stop,restart} to support passenger:
namespace :deploy do
  task(:start) {}
  task(:stop) {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
