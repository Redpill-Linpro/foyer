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

class AddNoEmptyTitleConstraintToPortletRelations < ActiveRecord::Migration
  def self.up
    execute %{UPDATE customer_portlet_relations SET title = NULL WHERE title = '';}
    execute %{ALTER TABLE customer_portlet_relations ADD CONSTRAINT no_empty_title CHECK (title != '');}
  end

  def self.down
    execute %{ALTER TABLE customer_portlet_relations DROP CONSTRAINT no_empty_title;}
  end
end