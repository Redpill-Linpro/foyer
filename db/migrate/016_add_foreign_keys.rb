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

class AddForeignKeys < ActiveRecord::Migration
  def self.up
    # Make sure the tables with custom ID column actually marks the id-field as primary:
    execute %{ALTER TABLE customers ADD PRIMARY KEY (id);}
    execute %{ALTER TABLE roles ADD PRIMARY KEY (id);}
    execute %{ALTER TABLE users ADD PRIMARY KEY (id);}

    # Add all associations as foreign keys in order to guard against data
    # corruption (which could manifest itself via the ldap sync script).
    #
    # User and customer table are synced via LDAP. Any constraints associated
    # with those tables must therefore be deferrable.
    #
    # Associations that are :depend => :destroy in active record are given "on
    # delete cascade" so that external tools (and old migrations that delete
    # data) can run without problems.
    add_foreign_key :customer_portlet_relation, :customer,                    :deferrable => true,  :cascade_delete => true
    add_foreign_key :customer_portlet_relation, :user, :created_by_user_id,   :deferrable => true
    add_foreign_key :customer_portlet_relation, :user, :updated_by_user_id,   :deferrable => true

    add_foreign_key :customer, :user, :created_by_user_id,                    :deferrable => true
    add_foreign_key :customer, :user, :updated_by_user_id,                    :deferrable => true

    add_foreign_key :role, :user, :created_by_user_id,                        :deferrable => true
    add_foreign_key :role, :user, :updated_by_user_id,                        :deferrable => true

    add_foreign_key :user_customer_relation, :user,                           :deferrable => true,  :cascade_delete => true
    add_foreign_key :user_customer_relation, :customer,                       :deferrable => true,  :cascade_delete => true
    add_foreign_key :user_customer_relation, :user, :created_by_user_id,      :deferrable => true
    add_foreign_key :user_customer_relation, :user, :updated_by_user_id,      :deferrable => true

    add_foreign_key :user, :role
    add_foreign_key :user, :user, :created_by_user_id,                        :deferrable => true
    add_foreign_key :user, :user, :updated_by_user_id,                        :deferrable => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, %(Data has been destroyed.)
  end
end
