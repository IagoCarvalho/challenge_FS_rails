class AddFollowersToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :followers, :integer
  end
end
