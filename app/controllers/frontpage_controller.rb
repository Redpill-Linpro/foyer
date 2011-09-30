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

class FrontpageController < ApplicationController

  def index
    # params[:customer] might be an array.
    customer_name = [params[:customer]].flatten.join
    customer_name = nil unless customer_name.to_s.chars.any?

    if name = customer_name
      if @current_customer = current_user.customers.find {|c| c.name.downcase == name.downcase}
        # OK

      elsif current_user.role.can_administrate? and @current_customer = Customer.find(:first, :conditions => [ "lower(name) = ?", name.downcase ])
        # OK

      else
        flash[:notice] = %(Customer "#{customer_name}" does not exist or is not associated with you.)
        redirect_to(root_url) unless request.xhr?
        return
      end
    end

    @customers = current_user.customers
    @customers.reject! { |c| c.portlet_relations.empty? }

    @current_customer ||= @customers.first
    session[:current_customer_id] = @current_customer ? @current_customer.id : nil

    if @current_customer
      @page_title = @current_customer.name

      if (title = params[:portlet]).to_s.chars.any?
        if @portlet = @current_customer.portlet_relations.find_by_title(title)
          # OK

        elsif @portlet = @current_customer.portlet_relations.find_by_portlet_name(title)
          # OK

        else
          flash[:notice] = %(Menu item "#{params[:portlet]}" does not exist for #{@current_customer.name}.)
          redirect_to(root_url + URI.escape(@current_customer.name)) unless request.xhr?
        end
      end

      # set default portlet if none is chosen
      @portlet ||= @current_customer.portlet_relations.sort_by {|rel| rel.priority}.first
    end
  end

end