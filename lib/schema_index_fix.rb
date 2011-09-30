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

# To use, add to config/environment.rb:
# ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send :include, SchemaIndexFix
module SchemaIndexFix

  def self.included(base)
    base.class_eval do
      alias :indexes_old :indexes

      def indexes(table_name, name = nil)
        # Call the old indexes method and filter out index definitions where
        # the column names are empty. If it's empty the resulting
        # add_index-phrase will be invalid.
        #
        # It's empty if activerecord doesn't understand/support the index
        # syntax. Our custom index from migration 015 requires this hack.
        indexes_old(table_name, name).select do |ind|
          ind.columns.compact.any? or puts "Ignoring index #{ind.inspect}"
        end
      end
    end
  end

end