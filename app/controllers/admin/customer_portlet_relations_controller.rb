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

class Admin::CustomerPortletRelationsController < Admin::BaseController

  active_scaffold :customer_portlet_relations do |config|
    # subform is needed to get edit_associated etc.
    config.actions = %w{list show create update delete subform}

    config.show.columns   = %w(customer title portlet_name text priority portlet_attributes created_by updated_by created_at updated_at)
    config.list.columns   = %w(customer title portlet_name text priority portlet_attributes)
    config.update.columns = %w(customer title portlet_name text priority portlet_attributes)
    config.create.columns = %w(customer title portlet_name text priority portlet_attributes)

    config.columns[:customer].form_ui = :select
    config.columns[:customer].associated_limit = nil

    config.columns[:portlet_name].form_ui = :select
    config.columns[:portlet_name].options = { :options => PortletLib::portlets }

    # The default form_ui is "subform", which is what we want.
    #config.columns[:portlet_attributes].form_ui = :subform

    # Ah, couldn't get nested to work. I only get a "interning empty string"
    # exception, so turn it off (excluding it from actions above apparently
    # isn't enough):
    config.columns[:portlet_attributes].clear_link

    config.list.sorting = { :customer => :asc }
  end

  private

  def before_create_save(record)
    record.created_by = record.updated_by = current_user
    record.portlet_attributes.each do |att|
      att.created_by = att.updated_by = current_user if att.new_record?
    end
  end

  def before_update_save(record)
    record.updated_by = current_user
    record.portlet_attributes.each do |att|
      att.created_by = att.updated_by = current_user if att.new_record?
    end
  end

end