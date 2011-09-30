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

require 'portletlib'

class CustomerPortletRelation < ActiveRecord::Base
  belongs_to :customer

  # Hah, don't call this attributes :-p
  has_many :portlet_attributes, :class_name => "PortletAttribute", :dependent => :destroy

  include CreatedAndUpdatedBy

  validates_presence_of :customer, :portlet_name, :title, :priority
  validates_uniqueness_of :title, :scope => :customer_id

  validates_inclusion_of :portlet_name, :in => PortletLib::portlets, :message => "must be one of: #{PortletLib::portlets.join(", ")}."

  before_validation :set_title

  # Respond to portlet attribute names directly. So if a portlet relation "rel"
  # has the attribute "url" with value "http://example.com", calling "rel.url"
  # will return "http://example.com".
  def method_missing(method, *args)
    att = portlet_attribute?(method.to_s) or return super
    att.value
  end

  def respond_to?(method, with_private=false)
    super or portlet_attribute?(method.to_s)
  end

  private

  # Set the title to a "human friendly" version of portlet name, if not set
  # already.
  def set_title
    self.title = portlet_name.capitalize.gsub(/(_)(.)/) {|groups| " " + groups.last.upcase } unless title.to_s.chars.any?
  end

  # Retrive the portlet attribute corresponding to given argument.
  def portlet_attribute?(name)
    portlet_attributes.find_by_name(name)
  end

end