require 'spec_helper'

describe "Groups" do
  describe "GET /groups" do
    login_user
    
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get groups_path
      response.status.should be(200)
    end
  end
end
