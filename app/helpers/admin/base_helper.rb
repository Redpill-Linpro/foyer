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

module Admin::BaseHelper

  def admin_controllers
    Dir["app/controllers/admin/*.rb"].map {|path| File.basename path, "_controller.rb"} - ["base"]
  end

  def current_controller_name
    name = humanize(@controller.controller_name)
    name == "Base" ? "<span>Model</span>" : name
  end

  def created_by(model, record)
    users = User.all.sort_by { |u| u.username }.map { |u| [u.id, u.username] }
    name = snakealize(model.name) + "[created_by_user_id]"

    selected = record.created_by_user_id || current_user.id
    select_tag name, options_for_select(users, selected)
  end

  def updated_by(model, record)
    users = User.all.sort_by { |u| u.username }.map { |u| [u.id, u.username] }
    name = snakealize(model.name) + "[updated_by_user_id]"

    select_tag name, options_for_select(users, current_user.id)
  end

  def menu_controller_select(selected_name=nil)
    selected = url_for(:controller => selected_name) if selected_name

    controllers = %w(customers users roles).map do |controller|
      [humanize(controller), url_for(:controller => controller)]
    end

    controllers.unshift(["-- Controller --", ""]) unless selected
    auto_redirect_js = %{var url = $(this).getValue(); window.location = url;}

    select_tag "controllers", options_for_select(controllers, selected), :onchange => auto_redirect_js
  end

end