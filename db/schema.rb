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

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 19) do

  create_table "customer_portlet_relations", :force => true do |t|
    t.string   "customer_id",                          :null => false
    t.string   "portlet_name",                         :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "created_by_user_id",                   :null => false
    t.string   "updated_by_user_id",                   :null => false
    t.integer  "priority",           :default => 1000, :null => false
    t.string   "title",                                :null => false
    t.text     "text"
  end

  add_index "customer_portlet_relations", ["created_by_user_id"], :name => "index_customer_portlet_relations_on_created_by_user_id"
  add_index "customer_portlet_relations", ["customer_id"], :name => "index_customer_portlet_relations_on_customer_id"
  add_index "customer_portlet_relations", ["updated_by_user_id"], :name => "index_customer_portlet_relations_on_updated_by_user_id"

  create_table "customers", :id => false, :force => true do |t|
    t.string   "id",                 :null => false
    t.string   "handle",             :null => false
    t.string   "name",               :null => false
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "created_by_user_id", :null => false
    t.string   "updated_by_user_id", :null => false
    t.date     "valid_from"
    t.date     "valid_to"
  end

  add_index "customers", ["created_by_user_id"], :name => "index_customers_on_created_by_user_id"
  add_index "customers", ["handle"], :name => "index_customers_on_handle", :unique => true
  add_index "customers", ["id"], :name => "index_customers_on_id", :unique => true
  add_index "customers", ["name"], :name => "index_customers_on_name", :unique => true
  add_index "customers", ["updated_by_user_id"], :name => "index_customers_on_updated_by_user_id"

  create_table "portlet_attributes", :force => true do |t|
    t.integer  "customer_portlet_relation_id",                 :null => false
    t.string   "name",                         :limit => 1023, :null => false
    t.string   "value",                        :limit => 1023
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by_user_id",                           :null => false
    t.string   "updated_by_user_id",                           :null => false
  end

  add_index "portlet_attributes", ["created_by_user_id"], :name => "index_portlet_attributes_on_created_by_user_id"
  add_index "portlet_attributes", ["updated_by_user_id"], :name => "index_portlet_attributes_on_updated_by_user_id"

  create_table "roles", :id => false, :force => true do |t|
    t.string   "id",                                    :null => false
    t.string   "handle",                                :null => false
    t.string   "name",                                  :null => false
    t.text     "description"
    t.boolean  "can_administrate",   :default => false, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "created_by_user_id",                    :null => false
    t.string   "updated_by_user_id",                    :null => false
  end

  add_index "roles", ["created_by_user_id"], :name => "index_roles_on_created_by_user_id"
  add_index "roles", ["handle"], :name => "index_roles_on_handle", :unique => true
  add_index "roles", ["id"], :name => "index_roles_on_id", :unique => true
  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true
  add_index "roles", ["updated_by_user_id"], :name => "index_roles_on_updated_by_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_customer_relations", :force => true do |t|
    t.string   "user_id",            :null => false
    t.string   "customer_id",        :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "created_by_user_id", :null => false
    t.string   "updated_by_user_id", :null => false
  end

  add_index "user_customer_relations", ["created_by_user_id"], :name => "index_user_customer_relations_on_created_by_user_id"
  add_index "user_customer_relations", ["updated_by_user_id"], :name => "index_user_customer_relations_on_updated_by_user_id"
  add_index "user_customer_relations", ["user_id", "customer_id"], :name => "index_user_customer_relations_on_user_id_and_customer_id", :unique => true

  create_table "users", :id => false, :force => true do |t|
    t.string   "id",                 :null => false
    t.string   "username",           :null => false
    t.string   "full_name"
    t.string   "password"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "created_by_user_id", :null => false
    t.string   "updated_by_user_id", :null => false
    t.string   "role_id",            :null => false
    t.string   "email"
    t.string   "phonenumber"
  end

  add_index "users", ["created_by_user_id"], :name => "index_users_on_created_by_user_id"
  add_index "users", ["id"], :name => "index_users_on_id", :unique => true
  add_index "users", ["role_id"], :name => "index_users_on_role_id"
  add_index "users", ["updated_by_user_id"], :name => "index_users_on_updated_by_user_id"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end