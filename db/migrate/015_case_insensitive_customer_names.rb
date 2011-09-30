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

class CaseInsensitiveCustomerNames < ActiveRecord::Migration
  def self.up
    # We want our unique constraints enforced in the database as well (since we
    # assume they're enforced and don't provide any fallbacks). This adds case
    # insensitive uniqueness check for customers.name.
    #
    # It is added to db/schema_extra.rb so newly created databases gets it as
    # well.
    execute %(CREATE UNIQUE INDEX customers_lower_name_index on customers (lower(name));)
  end

  def self.down
    execute %(DROP INDEX customers_lower_name_index;)
  end
end