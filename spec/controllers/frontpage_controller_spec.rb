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

require 'spec_helper'

describe FrontpageController do
  integrate_views

  describe "when a user is logged in" do
    before :each do
      @user = $user = Factory(:user)

      ApplicationHelper.class_eval { def current_user; $user; end }

      controller.stub!(:current_user).and_return(@user)
      controller.stub!(:authenticate).and_return(true)
    end

    it "GET 'index' should be successful" do
      get 'index'
      response.should be_success
    end

    it "GET 'index' with non-existant customer should be successful" do
      get 'index', :customer => "asdfl2 3fl2fj"
      response.should be_redirect
    end

    it "GET 'index' with non-existant customer & portlet should be successful" do
      get 'index', :customer => "asdfl2 3fl2fj", :portlet => "lksaf li2"
      response.should be_redirect
    end

  end

  describe "when a user is NOT logged in" do
    it "GET 'index' should fail" do
      get 'index'
      response.response_code.should == 401 # unauthorized
    end
  end

end