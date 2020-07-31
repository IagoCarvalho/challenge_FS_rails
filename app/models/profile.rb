class Profile < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness:true
    validates :git_url, presence: true
    validates :git_url, uniqueness: true
    validates :git_username, presence: true
    validates :followers, presence: true
    validates :following, presence: true
    validates :stars_given, presence: true
    validates :profile_pic_url, presence: true
    validates :last_years_contributions, presence: true

    # Method to query the Profile objects with a search param
    # @param [String] search String to be searched on name, git_username, location or organizations
    # @return [Profile] Object query if string match or all objects
    def self.search(search)
        profiles = all
        
        if search
            results = profiles.where("name LIKE ? OR git_username LIKE ? OR organizations LIKE ? OR localization LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
            unless results.nil?
                profiles = results
            end
        end

        return profiles
    end
end
