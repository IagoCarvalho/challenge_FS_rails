class Profile < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness:true
    validates :git_url, presence: true
    validates :git_url, presence: true
    validates :git_username, presence: true
    validates :followers, presence: true
    validates :following, presence: true
    validates :stars_given, presence: true
    validates :profile_pic_url, presence: true
    validates :last_years_contributions, presence: true
end
