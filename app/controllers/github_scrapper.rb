require 'nokogiri'
require 'httparty'
require 'shorturl'


module GithubScrapper

    # Method to webscrap the html of the github user profile page to retrieve data
    # @param [String] profile_url The github link to the profile
    # @return [Hash] user_profile Retrieved user data
    def web_scrap_user_profile(profile_url)

        shortened_url = shorten_url(profile_url)
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
        last_years_contributions = last_years_contributions.scan(/\d+/)[0]

        user_profile = {
            shortened_url: shortened_url,
            git_username: git_username,
            followers: followers,
            following: following,
            stars_given: stars_given,
            last_years_contributions: last_years_contributions,
            profile_pic_url: profile_pic_url,
        }

        # Append optional params
        profile_organizations = parsed_profile_page.css('a.avatar-group-item')
        localization = parsed_profile_page.css('ul.vcard-details span.p-label')
        
        unless localization.empty?
            localization = localization.first.text.strip()
            user_profile[:localization] = localization
        end

        unless profile_organizations.empty?
            organizations = Array.new
            for org in profile_organizations do
                organizations.push(org['aria-label'])
            end
            organizations = organizations.join(', ')

            user_profile[:organizations] = organizations
        end

        return user_profile
    end

    # Method to shorten url using external services, Default service = tinyurl
    # @param [String] url Url to be shortened
    # @return [String] shortened_url Shortened url if no external services exceptions occurr
    def shorten_url(url)
        begin
            shortened_url = ShortURL.shorten(url, :tinyurl)
        rescue
            shortened_url = url
        end

        return shortened_url
    end

end

