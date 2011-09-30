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

class Admin::RolesController < Admin::BaseController

  active_scaffold :roles do |config|
    config.actions = %w(list show create update delete)

    config.show.columns = %w{name handle can_administrate description created_by updated_by created_at updated_at}
    config.list.columns = %w{name handle can_administrate description}

    # handle is only set during create.
    config.create.columns = %w{name handle can_administrate description}
    config.update.columns = %w{name can_administrate description}

    config.list.sorting = { :name => :asc }
  end

  private

  def before_create_save(model)
    model.created_by = model.updated_by = current_user
  end

  def before_update_save(model)
    model.updated_by = current_user
  end

end