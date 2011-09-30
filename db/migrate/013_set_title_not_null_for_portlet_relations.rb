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

class SetTitleNotNullForPortletRelations < ActiveRecord::Migration
  def self.up
    CustomerPortletRelation.all.each do |relation|
      # New code should correctly set the title.
      relation.save!
    end

    change_column :customer_portlet_relations, :title, :string, :null => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigrationException
  end
end