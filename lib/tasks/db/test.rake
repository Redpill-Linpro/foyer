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

namespace :db do
  namespace :test do

    task :prepare do
      # Seed the database after it is prepared for tests:
      # This is needed to solve the "chicken and egg"-problem that I for some
      # reason decided to create with the User model: The User model has a
      # required created_by (user_id) field ... heh ...
      #
      # So anyway we seed the database so that the tests already have a user
      # object available at all times.
      Rake::Task["db:seed"].invoke
    end

  end
end