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

class Customer < ActiveRecord::Base
  has_many :user_relations, :class_name => "UserCustomerRelation", :dependent => :destroy
  has_many :users, :through => :user_relations

  has_many :portlet_relations, :class_name => "CustomerPortletRelation", :dependent => :destroy

  include CreatedAndUpdatedBy

  validates_presence_of   :handle, :name
  validates_uniqueness_of :handle, :name, :case_sensitive => false

  # only allow to set handle during create
  attr_readonly :handle

  before_create :set_id

  # Portlets are not models, they are controllers. But getting a list of
  # their names is useful.
  def portlets
    portlet_relations.sort_by {|rel| rel.priority }.map { |rel| rel.portlet_name }
  end

  protected

  def set_id
    self.id = self.handle
  end

end