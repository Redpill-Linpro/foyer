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

class Portlet::GraphController < Portlet::BaseController
  before_filter :set_portlet

  def show
    options = {}

    if graph = GENERAL[:portlets][:graph] and auth = graph[:auth]
      options[:basic_auth] = {
        :username => auth[:username],
        :password => auth[:password]
      }
    end

    if @indexed.to_s.chars.any?
      url = URI.parse(URI.escape(@indexed))
      options[:host] = url.host
      options[:port] = url.port
      options[:path] = url.path
      options[:path] += "?" + url.query if url.query

      if url.user
        options[:basic_auth] = {
          :username => url.user,
          :password => url.password
        }
      end

      # fetch_proxy_response will trigger an exception if the fetch is
      # somehow unsuccessful.
      response = fetch_proxy_response(options)

      case response.content_type.to_s.downcase
      when /image/
        send_data response.body,
        :type => response.content_type,
        :disposition => "inline"

      else
        raise "Unsupported content type: '#{response.content_type.to_s}'."
      end

    else
      render :text => "Portlet has no URL."
    end
  end

  protected

  def set_portlet
    if not current_customer_id = session[:current_customer_id]
      render :text => "No customer chosen."
      return false

    elsif not customer = Customer.find_by_id(current_customer_id)
      raise "User #{current_user.id} managed to get current_customer_id equal " +
        "#{current_customer_id}, but that customer does not exist!"

    elsif not current_user.customers.include? customer
      raise "User #{current_user.id} managed to get current_customer_id equal " +
        "#{current_customer_id}, but that customer is not associated with " +
        "current user! (user customers: #{current_user.customers.inspect})"

    else
      title = params[:portlet]
      @portlet = CustomerPortletRelation.find_by_customer_id_and_title(customer.id, title)

      unless @portlet and @portlet.portlet_name == "graph"
        render :text => "No (graph) portlet relation chosen."
        return false
      else
        index = params[:index].to_s.to_i
        @indexed = @portlet.url.to_s.split[index]
      end
    end
  end
end