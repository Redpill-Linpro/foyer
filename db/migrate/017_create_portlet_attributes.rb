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

class CreatePortletAttributes < ActiveRecord::Migration
  def self.up
    create_table :portlet_attributes do |t|
      t.integer :customer_portlet_relation_id, :null => false

      t.string  :name,  :limit => 1023, :null => false
      t.string  :value, :limit => 1023

      t.timestamps
    end

    add_created_and_updated_by :portlet_attributes

    add_foreign_key :portlet_attribute, :customer_portlet_relation
    add_foreign_key :portlet_attribute, :user, :created_by_user_id, :deferrable => true
    add_foreign_key :portlet_attribute, :user, :updated_by_user_id, :deferrable => true

    mig_log "Creating customer portlet relations from 'url' column values:"
    CustomerPortletRelation.all.each do |rel|
      if rel.url.to_s.chars.any?
        att = PortletAttribute.create!(
          :customer_portlet_relation => rel,
          :name => "url",
          :value => rel.url,
          :created_by => rel.created_by,
          :updated_by => rel.updated_by
        )
        mig_log att.to_yaml, "-" * 79
      end
    end

    # Bye bye love.
    remove_column :customer_portlet_relations, :url
  end

  def self.down
    add_column :customer_portlet_relations, :url, :string, :limit => 1023

    PortletAttribute.all.each do |att|
      raise "Unknown attribute: #{att.inspect}" unless att.name == "url"
      raise "URL is empty: #{att.inspect}" unless att.value.to_s.chars.any?

      rel = att.customer_portlet_relation
      rel.url = att.value
      rel.save!
    end

    drop_table :portlet_attributes
  end
end