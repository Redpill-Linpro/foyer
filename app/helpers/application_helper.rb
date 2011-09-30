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

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current_user
    User.find_by_username(session[:username])
  end

  # humanize turns "string_with_underscores" to "String With Underscores"
  def humanize(string)
    string.capitalize.gsub(/(_)(.)/) {|groups| " " + groups.last.upcase }
  end

  # snakealize turns "StringWithoutUnderscores" to "string_without_underscores"
  def snakealize(string)
    string.gsub(/(.)([A-Z])/) {|groups| groups.first + "_" + groups.last }.downcase
  end

  # This is needed by haml templates
  def flash_messages
    flash || {}
  end

  # Customer select for customers that have at least one portlet.
  def menu_customer_select(selected_name="")
    customers = current_user.customers.select do |customer|
      customer.portlet_relations.any?
    end

    customers = customers.map do |customer|
      [customer.name, "/" + URI.encode(customer.name)]
    end

    customers = customers.sort_by { |customer| customer.first }

    auto_redirect_js = %{var url = $(this).getValue(); window.location = url;}

    select_tag "customers",
      options_for_select(customers, "/" + URI.encode(selected_name)),
      :onchange => auto_redirect_js
  end

  def show_contact_info_js
    %{ $('contact_information').toggle(); }
  end
end