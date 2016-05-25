require 'test_helper'

class BaseballMatchupControllerTest < ActionController::TestCase
  test "should get scrape" do
    get :scrape
    assert_response :success
  end

  test "should get update_teams" do
    get :update_teams
    assert_response :success
  end

end
