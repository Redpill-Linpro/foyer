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

require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :role

  has_many :customer_relations, :class_name => "UserCustomerRelation", :dependent => :destroy
  has_many :customers, :through => :customer_relations

  # These are probably not needed, but what the heck:
  has_many :created_customers, :class_name => "Customer", :foreign_key => :created_by_user_id
  has_many :updated_customers, :class_name => "Customer", :foreign_key => :updated_by_user_id

  has_many :created_roles, :class_name => "Role", :foreign_key => :created_by_user_id
  has_many :updated_roles, :class_name => "Role", :foreign_key => :updated_by_user_id

  # Note: This has_many association pair to the User model had to be the last
  # pair for admin_data not to be confused. Since the order doesn't matter
  # these associations are setup incorrectly, or there is a bug in admin_data.
  has_many :created_users, :class_name => "User", :foreign_key => :created_by_user_id
  has_many :updated_users, :class_name => "User", :foreign_key => :updated_by_user_id

  include CreatedAndUpdatedBy

  validates_presence_of   :username, :role
  validates_uniqueness_of :username

  # only allow to set username during create
  attr_readonly :username

  before_create :encrypt_password
  before_create :set_id

  # Used by active_scaffold:
  def label
    username
  end

  # valid_login? assumes that self is a new user with authentication data
  # that is supposed to match an existing user. If a user with the supplied
  # username is found and the users password matches the stored user is
  # returned, otherwise nil is returned.
  def valid_login?
    if user = User.find_by_username(self.username) and user.password == User.encrypt(self.password)
      user
    else
      nil
    end
  end

  # Update the users password to the given new password.
  # This is needed to encrypt the password.
  def update_password(new_password)
    self.password = User.encrypt(new_password)
  end

  def customers
    if role.can_administrate?
      Customer.all
    else
      # The database might contain bad references, in which case rel.customer
      # below will return 'nil', which is unexpected, so we need to run a
      # 'compact' on the array to remove them, in case they pop up.
      #
      # Of course, you're not supposed to have bad data in your database, so
      # an exception might be justified after all, however I think the only
      # way to solve the problem properly is to add proper foreign keys to
      # the database (some time in the future..). So until then, remove nils.
      UserCustomerRelation.find_all_by_user_id(id).map { |rel| rel.customer }.compact
    end
  end

  # list_name returns the name in a "list friendly" format
  def list_name
    name = full_name.split(' ')

    [name.pop, name.join(' ')].compact.grep(/.+/).join(', ')
  end

  protected

  SALT = %{7dqqZuUJFgrvSRZCxswzjH4oKZAMDVwZmPq5XCF5nW5XRqp1n40L0KuHkko06K7C}

  def self.encrypt(string)
    Digest::SHA1.hexdigest(SALT + "$" + string)
  end

  # encrypt the users password when the user is created
  def encrypt_password
    self.password = User.encrypt(self.password) if self.password
  end

  def set_id
    self.id = self.username
  end
end