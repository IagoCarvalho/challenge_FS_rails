class AddStarsGivenToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :stars_given, :integer
  end
end
