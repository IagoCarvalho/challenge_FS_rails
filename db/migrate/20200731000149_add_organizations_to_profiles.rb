class AddOrganizationsToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :organizations, :string
  end
end
