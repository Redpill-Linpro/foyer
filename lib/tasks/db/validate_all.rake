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

namespace :db do

  # Let's say you add or change a validation for a model and forget to update
  # existing rows. This rake task finds and displays those.
  desc "Validate all objects found for all models. Finds inconsistencies in the database."
  task :validate_all => :environment do
    models = Dir["app/models/*"].map{|s| File.basename(s, ".rb").split("_").map{|w| w.capitalize}.join}.sort
    models = models.map {|name| eval name}.select {|c| c.is_a? Class and c.superclass == ActiveRecord::Base}

    sum = 0
    models.each do |model|
      tmp_sum = 0
      model.all.each_with_index do |obj, idx|
        unless obj.valid?
          puts "-" * 79
          puts "The following object has validation errors:\n - " + obj.errors.full_messages.join("\n - "), ""
          puts obj.to_yaml
        end
        tmp_sum = idx
      end
      sum += tmp_sum - 1
    end
    puts "-" * 79, "Processed #{sum} records."
  end

end