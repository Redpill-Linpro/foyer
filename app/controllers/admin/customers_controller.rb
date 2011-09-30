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

class Admin::CustomersController < Admin::BaseController

  active_scaffold :customers do |config|

    # We get everything except the portlet relations from LDAP.
    config.actions = %w{list search show nested}

    config.show.columns   = %w(handle name description portlet_relations user_relations created_by updated_by created_at updated_at)
    config.list.columns   = %w(handle name description portlet_relations user_relations)

    config.columns[:users].associated_limit = nil
    config.columns[:user_relations].associated_limit = nil
    config.columns[:portlet_relations].associated_limit = nil

    config.nested.add_link("Edit portlet relations", :portlet_relations)

    config.list.sorting = { :handle => :asc }
  end

end