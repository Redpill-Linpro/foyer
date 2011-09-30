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

Sass::Plugin.options[:template_location]  = Rails.root.join("app/stylesheets").to_s
Sass::Plugin.options[:css_location]       = Rails.root.join("public/stylesheets/compiled").to_s

Sass::Plugin.options[:style] = :compact

# Show exception in-page during development or (false) always raise exception?
Sass::Plugin.options[:full_exception] = false