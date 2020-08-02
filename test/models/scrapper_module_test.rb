require 'test_helper'
require 'github_scrapper'

    
class GithubScrapperTest < ActiveSupport::TestCase
    include GithubScrapper
    
    test "should not be able to fetch a invalid url" do
        invalid_git_url = profiles(:invalid_user_profile_1).git_url
        assert_raises(Exception) do
            invalid_fetch = web_scrap_user_profile(invalid_git_url)
        end
    end

    test "should fetch valid url" do
        valid_profile_url = profiles(:valid_user_profile_1).git_url

        assert_nothing_raised {
            fetched_data = web_scrap_user_profile(valid_profile_url)
        }
        fetched_data = web_scrap_user_profile(valid_profile_url)
        assert_not(fetched_data.empty?)
    end

    test "should fetch optional profile attributes" do
        url = profiles(:user_profile_with_opt_params).git_url
        fetched_data = web_scrap_user_profile(url)

        assert_not fetched_data.nil? and fetched_data.empty?
        assert_not fetched_data[:organizations].nil? and fetched_data[:localization].nil?
    end

    test "should fetch profile without optional attributes" do
        url = profiles(:user_profile_without_opt_params).git_url
        fetched_data = web_scrap_user_profile(url)

        assert_not fetched_data.nil? and fetched_data.empty?
        assert fetched_data[:organizations].nil? and fetched_data[:localization].nil?
    end

    test "should correctly recover static data" do
        url = profiles(:my_data).git_url
        fetched_data = web_scrap_user_profile(url)

        assert_equal fetched_data[:localization], profiles(:my_data).localization
        assert_equal fetched_data[:git_username], profiles(:my_data).git_username
        assert_equal fetched_data[:profile_pic_url], profiles(:my_data).profile_pic_url
    end
end
