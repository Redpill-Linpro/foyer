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

class Admin::UsersController < Admin::BaseController

  active_scaffold :users do |config|

    # We get everything except permissions (role) from LDAP.
    config.actions = %w{list show update search nested}

    config.show.columns   = %w{username full_name email phonenumber customer_relations role created_by updated_by created_at updated_at}
    config.list.columns   = %w{username full_name email phonenumber customer_relations role}
    config.update.columns = %w{role}

    config.columns[:role].form_ui = :select
    config.columns[:customer_relations].form_ui = :select
    config.columns[:customer_relations].associated_limit = nil

    config.list.sorting = { :username => :asc }
  end

  private

  def before_update_save(model)
    model.updated_by = current_user
  end

end