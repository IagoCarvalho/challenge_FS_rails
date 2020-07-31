class AddLastYearsContributionsToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :last_years_contributions, :integer
  end
end
