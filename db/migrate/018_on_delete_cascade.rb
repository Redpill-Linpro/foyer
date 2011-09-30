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

class OnDeleteCascade < ActiveRecord::Migration
  def self.up
    # Set associations who are on the reverse end of :dependent => :destroy in
    # active record to automatically be deleted in postgres.
    #
    # This is a redundant thing to do, but it allows external tools (not to
    # mention migrations that can't use active record due to schema changes) to
    # delete records.
    remove_foreign_key  :customer_portlet_relation, :customer
    remove_foreign_key  :user_customer_relation, :user
    remove_foreign_key  :user_customer_relation, :customer
    remove_foreign_key  :portlet_attribute, :customer_portlet_relation

    add_foreign_key     :customer_portlet_relation, :customer,          :deferrable => true,  :cascade_delete => true
    add_foreign_key     :user_customer_relation, :user,                 :deferrable => true,  :cascade_delete => true
    add_foreign_key     :user_customer_relation, :customer,             :deferrable => true,  :cascade_delete => true
    add_foreign_key     :portlet_attribute, :customer_portlet_relation,                       :cascade_delete => true
  end

  def self.down
    remove_foreign_key  :customer_portlet_relation, :customer
    remove_foreign_key  :user_customer_relation, :user
    remove_foreign_key  :user_customer_relation, :customer
    remove_foreign_key  :portlet_attribute, :customer_portlet_relation

    add_foreign_key     :customer_portlet_relation, :customer,          :deferrable => true
    add_foreign_key     :user_customer_relation, :user,                 :deferrable => true
    add_foreign_key     :user_customer_relation, :customer,             :deferrable => true
    add_foreign_key     :portlet_attribute, :customer_portlet_relation
 end
end