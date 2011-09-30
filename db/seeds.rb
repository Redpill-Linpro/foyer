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

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# How to solve the chicken & egg problem? By using a transaction together with
# deferrable constraints.
ActiveRecord::Base.transaction do

  # Create admin role:
  admin_role = Role.new({
    :handle => "admin",
    :name => "Administrator",

    :description => "Can administrate the system:" \
      + " Create users / roles, assign roles to users, etc.",

    :can_administrate => true,

    :created_by_user_id => "admin",
    :updated_by_user_id => "admin",
  })

  # Don't validate when saving, since the created/updated_by user doesn't exist
  # yet.
  admin_role.save(false)

  # Create admin user:
  admin = User.new({
    :username => "admin",
    :password => "admin",

    :full_name => "Administrative user created as seed data",

    :role => admin_role,

    :created_by_user_id => "admin",
    :updated_by_user_id => "admin",
  })

  # Don't validate the user when it is saved, so that it may reference itself as
  # the creator/updator:
  admin.save(false)

end