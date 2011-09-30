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

# Add associations to the User model and validate these on save.
module CreatedAndUpdatedBy

  def self.included(base)
    base.class_eval do

      # add created_by and updated_by associations to User model
      belongs_to :created_by, :class_name => "User", :foreign_key => :created_by_user_id
      belongs_to :updated_by, :class_name => "User", :foreign_key => :updated_by_user_id

      validates_presence_of :created_by, :updated_by

    end
  end

end