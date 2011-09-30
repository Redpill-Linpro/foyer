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

class Admin::UserCustomerRelationsController < Admin::BaseController

  active_scaffold :user_customer_relations do |config|

    # We get this list from LDAP, so no editing.
    config.actions = %w(list)

    config.list.columns = %w(user customer created_by updated_by created_at updated_at)

    #config.columns[:user].link.action     = "show"
    #config.columns[:customer].link.action = "show"

    #config.columns[:user].form_ui = :select
    #config.columns[:customer].form_ui = :select
  end

end