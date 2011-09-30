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

def get_db_config
  config_file = Rails.root.join 'config', 'database.yml'
  config = YAML.load(IO.read(config_file))

  config[Rails.env] || {}
end

require 'active_record'

namespace :db do
  namespace :customer do

    desc "Create named customer (customer=customer)."
    task :create => :environment do
      raise %(Missing customer=something command line parameter.) unless handle = ENV["customer"]

      if customer = Customer.find_by_handle(handle)
        puts customer.inspect + " -> already exists"

      else
        customer = Customer.create!(:handle => handle, :name => handle, :created_by => User.first, :updated_by => User.first)
        puts customer.inspect + " -> created"
      end
    end

    desc "Delete named customer (customer=customer) together with any associated relations."
    task :delete => :environment do
      raise %(Missing customer=something command line parameter.) unless handle = ENV["customer"]
      unless customer = Customer.find_by_handle(handle)
        # The reason we create the customer is because we (probably) need to
        # tie up loose ends (associations referencing this non-existing
        # customer before the constraints we're put into place in the
        # database).
        customer = Customer.create!(:handle => handle, :name => handle, :created_by => User.first, :updated_by => User.first)
      end
      customer.destroy
      puts customer.inspect + " -> destroyed"
    end

    desc "Rename a customer: customer=old_handle to=new_handle."
    task :rename => :environment do
      raise %(Missing customer=old_handle command line parameter.) unless old_handle = ENV["customer"]
      raise %(Missing to=new_handle command line parameter.) unless new_handle= ENV["to"]
      customer = Customer.find(old_handle)
      inspect = customer.inspect

      customer.handle = new_handle
      customer.save!

      puts inspect + " -> " + customer.inspect
    end
  end
end