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

class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers, :id => false do |t|
      t.string    :id,                  :null => false
      t.string    :handle,              :null => false
      t.string    :name,                :null => false

      t.text      :description

      t.timestamps                      :null => false
    end

    add_created_and_updated_by :customers

    # the id will be the same as handle
    add_index :customers, :id,          :unique => true, :primary => true
    add_index :customers, :handle,      :unique => true
    add_index :customers, :name,        :unique => true
  end

  def self.down
    drop_table :customers
  end
end