require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest

  setup do
    #@valid_profile = profiles(:example_user)
  end

  test "should get new profile" do
    get new_profile_url
    assert_response :success
  end

  test "should create new profile" do
    assert_difference('Profile.count') do
      post profiles_url, params: {
        profile: {
          name: 'example', 
          git_url: 'https://github.com/example'
          }
        }
    end
  end

end
