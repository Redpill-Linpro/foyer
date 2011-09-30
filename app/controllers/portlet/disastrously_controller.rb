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

class Portlet::DisastrouslyController < Portlet::BaseController

  def index
    current_customer_id = session[:current_customer_id]

    if not current_customer_id
      render :text => "No customer chosen."

    elsif not customer = Customer.find_by_id(current_customer_id)
      raise "User #{current_user.id} managed to get current_customer_id equal " +
        "#{current_customer_id}, but that customer does not exist!"

    elsif not current_user.customers.include? customer
      raise "User #{current_user.id} managed to get current_customer_id equal " +
        "#{current_customer_id}, but that customer is not associated with " +
        "current user! (user customers: #{current_user.customers.inspect})"

    else
      options = {}

      if disastrously = GENERAL[:portlets][:disastrously]
        options.merge!({
          :host => disastrously[:host],
          :port => disastrously[:port],
        })

        if auth = disastrously[:auth]
          options[:basic_auth] = {
            :username => auth[:username],
            :password => auth[:password]
          }
        end
      end

      customer_name = customer.handle
      group_paths = disastrously ? disastrously[:group_paths] : {}

      # Group service windows: future
      options[:path] = group_paths[:future_servicewindows] + customer_name
      @group_future_service_windows = fetch_proxy_response(options).body

      # Group service windows: past
      options[:path] = group_paths[:past_servicewindows] + customer_name
      @group_past_service_windows = fetch_proxy_response(options).body

      # Group incidents: past
      options[:path] = group_paths[:past_incidents] + customer_name
      @group_past_incidents = fetch_proxy_response(options).body

      # Group SLA
      options[:path] = group_paths[:sla] + customer_name
      @group_sla = fetch_proxy_response(options).body
    end
  end

end