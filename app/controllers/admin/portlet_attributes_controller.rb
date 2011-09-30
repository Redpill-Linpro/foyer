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

class Admin::PortletAttributesController < ApplicationController

  active_scaffold :portlet_attributes do |config|
    config.actions = %w{list show create update delete subform}

    config.show.columns = %w(name value created_by updated_by created_at updated_at)
    config.list.columns = %w(name value)
    config.create.columns = %w(name value)
    config.update.columns = %w(name value)
  end

  private

  def before_create_save(record)
    record.created_by = record.updated_by = current_user
  end

  def before_update_save(record)
    record.updated_by = current_user
  end

end