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

ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # See how all your routes lay out with "rake routes"
  map.root :controller => "frontpage"

  # Map all portlets
  # (Note: watch out for greedy regexps: You need a question mark on the end here)
  map.connect ':controller/:action.:format',  :requirements => { :controller => /portlet\/(?!base).*?/ }

  map.admin '/admin', :controller => "admin/base"

  map.namespace :admin do |admin|
    # In order to allow dots in the id ("mail@example.com") we need to
    # explicitly allow it, or else rails will think the rest of the url is the
    # format (e.g. ".jpg").
    anything = /[^\/]+/
    admin.resources :users,
      :active_scaffold => true, :requirements => { :id => anything }, :only => %w{index show edit update search nested}

    admin.resources :roles,
      :active_scaffold => true, :requirements => { :id => anything }, :only => %w(index show new create edit update delete destroy)

    admin.resources :customers,
      :active_scaffold => true, :requirements => { :id => anything }, :only => %w{index search show nested}

    admin.resources :user_customer_relations,
      :active_scaffold => true, :requirements => { :id => anything }, :only => %w(index)

    admin.resources :customer_portlet_relations,
      :active_scaffold => true, :requirements => { :id => anything }, :only => %w{index show new create edit update delete destroy}

    admin.resources :portlet_attributes,
      :active_scaffold => true, :requirements => { :id => anything }, :only => %w{index show new create edit update delete destroy}
  end

  # standard route
  map.connect ':customer/:portlet', :controller => :frontpage

  # and glob everything else to the frontpage controller
  map.connect '*customer', :controller => :frontpage
end