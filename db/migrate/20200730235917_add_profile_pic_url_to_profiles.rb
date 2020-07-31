class AddProfilePicUrlToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :profile_pic_url, :string
  end
end
