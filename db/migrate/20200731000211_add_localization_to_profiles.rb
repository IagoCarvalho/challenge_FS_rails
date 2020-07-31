class AddLocalizationToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :localization, :string
  end
end
