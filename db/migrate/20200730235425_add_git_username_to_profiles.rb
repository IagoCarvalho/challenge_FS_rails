class AddGitUsernameToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :git_username, :string
  end
end
