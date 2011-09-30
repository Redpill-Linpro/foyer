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

class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles, :id => false do |t|
      t.string    :id,                  :null => false
      t.string    :handle,              :null => false
      t.string    :name,                :null => false

      t.text      :description

      t.boolean   :can_administrate,    :null => false, :default => false

      t.timestamps                      :null => false
    end

    add_created_and_updated_by :roles

    # id is always the same as handle (which makes handle redundant),
    # but we need handle so that we can manually set the id, since
    # active record has certain assumptions about the id that prevents this.
    add_index :roles, :id,      :unique => true, :primary => true
    add_index :roles, :handle,  :unique => true
    add_index :roles, :name,    :unique => true

    # add association from users (and index, since it's a foreign key)
    add_column :users, :role_id, :string, :null => false
    add_index  :users, :role_id
  end

  def self.down
    remove_column :users, :role_id
    drop_table :roles
  end
end