require 'nokogiri'
require 'httparty'
require 'byebug'


# Scrap the html of the user profile page to retrieve data
def scrap_user_profile(profile_url)

    profile_web_page = HTTParty.get(profile_url)

    if profile_web_page.code != 200
        raise "Ocorreu um erro ao recuperar o perfil da url #{profile_url}"
    end
    
    parsed_profile_page = Nokogiri::HTML(profile_web_page)

    git_username = parsed_profile_page.css('span.p-nickname').text
    followers =  parsed_profile_page.css('span.text-bold.text-gray-dark')[0].text
    following = parsed_profile_page.css('span.text-bold.text-gray-dark')[1].text
    stars_given = parsed_profile_page.css('span.text-bold.text-gray-dark')[2].text
    profile_pic_url = parsed_profile_page.css('img.avatar-user')[0].attributes["src"].value
    
    last_years_contributions = parsed_profile_page.css('h2.f4.text-normal').text
    last_years_contributions = last_years_contributions.scan(/\d+/)

    organizations = parsed_profile_page.css('.h-card div .avatar-group-item')

    localization = parsed_profile_page.css('ul.vcard-details').first.text
    localization = localization.strip()

    user_profile = {
        git_username: git_username,
        followers: followers,
        following: following,
        stars_given: stars_given,
        last_years_contributions: last_years_contributions,
        profile_pic_url: profile_pic_url,
    }

    unless localization.empty?
        user_profile[:localization] = localization
    end

    byebug
    return user_profile
end

url = "http://tinyurl.com/y3knbx6h"
scrap_user_profile(url)
