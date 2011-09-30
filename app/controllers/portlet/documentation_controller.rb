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

class Portlet::DocumentationController < Portlet::BaseController

  def download
    # The routing says ':action.:type' so that the link ends with
    # 'download.pdf'. This is needed to help the browser understand that it is
    # about to receive a pdf file (and handle it properly).

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

      if doc = GENERAL[:portlets][:documentation]
        options.merge!({
          :host => doc[:host],
          :port => doc[:port],
          :path => doc[:path] + customer.handle,
        })

        if auth = doc[:auth]
          options[:basic_auth] = {
            :username => auth[:username],
            :password => auth[:password]
          }
        end
      end

      # use custom url if available
      relation = CustomerPortletRelation.find_by_customer_id_and_portlet_name(customer.id, "documentation")

      if relation.url.to_s.chars.any?
        url = URI.parse(URI.escape(relation.url))
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
      end

      # fetch_proxy_response will trigger an exception if the fetch is
      # somehow unsuccessful.
      response = fetch_proxy_response(options)

      case response.content_type.to_s.downcase
      when 'text/html'        then render :text => response.body
      when 'text/plain'       then render :text => response.body
      when 'application/pdf'
        send_data response.body,
          :filename => "#{customer.name} Documentation.pdf",
          :type => "application/pdf",
          :disposition => "inline"

      else
        raise "Unsupported content type: '#{response.content_type.to_s}'."
      end
    end
  end

end