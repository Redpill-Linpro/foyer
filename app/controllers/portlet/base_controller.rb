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

class Portlet::BaseController < ApplicationController

  # Portlets are meant to be used as web services.
  # (In general we could just render portlets inline instead of using ajax,
  # but because we want to split it into different controllers,
  # Rails doesn't want us to render inline, so ajax it is)
  layout false

  before_filter :set_useful_params

  protected

  def set_useful_params
    @customer = Customer.find_by_id(session[:current_customer_id])
  end

  # fetch_proxy_response will do a get request against a host and return
  # the results. It will raise an exception unless the response returns an
  # HTTP success code.
  #
  # Options:
  #   :host (required)
  #   :port
  #   :path
  #   :basic_auth => {
  #     :username
  #     :password
  #   }
  def fetch_proxy_response(options={})
    host = options[:host]
    port = options[:port] || 80
    path = options[:path] || ''

    req = Net::HTTP::Get.new(path)

    if options[:basic_auth]
      username = options[:basic_auth][:username]
      password = options[:basic_auth][:password]
      req.basic_auth username, password
    end

    logger.info %{Doing proxy request against "#{host}:#{port}#{path}" (basic_auth: #{options.key?(:basic_auth)})...}

    http = Net::HTTP.new(host, port)
    http.use_ssl = (port.to_i == 443)

    # this might trigger an exception (host unreachable, etc) but that's okay,
    # we don't want to catch exceptions if they happen.
    response = http.request(req)

    if response.is_a? Net::HTTPSuccess
      response

    else
      options[:basic_auth].each_key { |key| options[:basic_auth][key] = "[FILTERED]" } if options[:basic_auth]
      msg = %(%s caused by %s:%s/%s) % [response.class.name, options[:host], options[:port], options[:path]]

      logger.error %(ERROR: %s\n%s\n%s) % [msg, options.inspect, response.body]
      raise msg
    end
  end

end