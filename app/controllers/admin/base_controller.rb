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

class Admin::BaseController < ApplicationController
  layout "admin"

  before_filter :authorize_admin
  before_filter :set_page_title

  protected

  def authorize_admin
    forbidden unless current_user.role.can_administrate?
  end

  def set_page_title
    unless self.class == Admin::BaseController
      @page_title = controller_name
      @current_controller = url_for(:controller => controller_name, :only_path => true)
    end
  end
end