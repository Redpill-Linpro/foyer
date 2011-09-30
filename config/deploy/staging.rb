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

# Staging environment
set :rails_env, "staging"

role :web, "web.staging.example.com"                    # Your HTTP server, Apache/etc
role :app, "app.staging.example.com"                    # This may be the same as your `Web` server
role :db,  "db.staging.example.com", :primary => true   # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# sudo should not be necessary for a deployment
set :use_sudo, false

# Which user to use during deployment, and where to deploy to
set :user, "foyer"
set :deploy_to, "/var/www/foyer"

set :keep_releases, 5
