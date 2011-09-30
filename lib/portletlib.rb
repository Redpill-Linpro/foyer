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

module PortletLib
  class << self

    # Name of controllers which are not actually portlets.
    META_CONTROLLERS = %w{base}

    # portlets returns a list with the names of all the portlets that exist.
    # The names are "system friendly," as in "portlet_name".
    def portlets
      portlet_controllers = Dir[RAILS_ROOT + "/app/controllers/portlet/*"]

      # clean up names
      portlet_names = portlet_controllers.map do |portlet|
        File.basename(portlet, "_controller.rb")
      end

      portlet_names - META_CONTROLLERS
    end

  end
end