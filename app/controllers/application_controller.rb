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

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "standard"

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :passwd

  # Generate exception notifications on staging/production:
  include ExceptionNotification::Notifiable

  # Make authentication the norm instead of the exception
  before_filter :authenticate

  protected

  def current_user
    # the username is unique and is used as primary key instead of id
    User.find_by_username(session[:username])
  end

  def authenticate
    if GENERAL[:users][:authentication_method] == "http_auth"

      authenticate_or_request_with_http_basic do |username, password|
        if user = User.find_by_username(username)
          session[:username] = user.username
        else
          # We basically have to raise an exception here since there is no way
          # to "kick out" the authenticated session. And since we don't have
          # any user object to log in with, we must halt / raise an exception.
          raise "The user '#{username}' does not exist in the db, and therefore can not log in."
        end
      end

    else
      # TODO: authenticate against password stored in db
      unless current_user
        render :text => "You are not authenticated", :status => :unauthorized
        return false
      end
    end

    true
  end

  def forbidden
    respond_to do |format|
      format.html { render :template => "shared/forbidden", :layout => "forbidden", :status => :forbidden }
      format.xml  { head :forbidden }
      format.json { head :forbidden }
    end
  end

end