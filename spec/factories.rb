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

Factory.define :role do |obj|
  obj.name()        { "role_#{Role.all.size + 1}" }
  obj.handle()      { "role_#{Role.all.size + 1}" }

  # Avoid infinite loop by not creating a new User object here:
  obj.created_by()  { User.last }
  obj.updated_by()  { User.last }
end

Factory.define :user do |obj|
  obj.username()    { "user_#{User.all.size + 1}" }
  obj.role()        { Factory(:role) }

  obj.created_by()  { User.last }
  obj.updated_by()  { User.last }
end

Factory.define :customer do |obj|
  obj.name()        { "Customer #{Customer.all.size + 1}" }
  obj.handle()      { "customer_#{Customer.all.size + 1}" }

  obj.created_by()  { Factory :user }
  obj.updated_by()  { User.last }
end

Factory.define :user_customer_relation do |obj|
  obj.user()        { Factory :user }
  obj.customer()    { Factory :customer }

  obj.created_by()  { User.last }
  obj.updated_by()  { User.last }
end

Factory.define :customer_portlet_relation do |obj|
  obj.customer()      { Factory :customer }
  obj.portlet_name()  { ports = PortletLib::portlets; ports[rand(ports.size)] }

  obj.created_by()    { Factory :user }
  obj.updated_by()    { User.last }
end