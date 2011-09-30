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

# Make methods available by adding the following to config/environment.rb:
# ActiveRecord::Migration.send :include, MigrationHelper
#
# The methods below will NOT be echoed to console during migration runs when
# they are executed.
module MigrationHelper

  def self.included(base)
    base.class_eval do
      class << self

        def add_created_and_updated_by(table)
          add_column table, :created_by_user_id, :string, :null => false
          add_column table, :updated_by_user_id, :string, :null => false

          add_index table, :created_by_user_id
          add_index table, :updated_by_user_id
        end

        # Migration log. Logs messages to log file named after the migration running.
        def mig_log(*msgs)
          unless @mig_log
            migration = File.basename(caller.find {|s| %r|/db/migrate/|.match(s)}.split(".rb:").first)
            filename = Rails.root.join("log/#{migration}.log")
            @mig_log = Logger.new(filename)
          end
          msgs.each { |msg| @mig_log.info(msg) }
        end

      end
    end
  end

end