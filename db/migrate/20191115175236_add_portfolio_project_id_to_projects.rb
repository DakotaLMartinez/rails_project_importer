class AddPortfolioProjectIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :portfolio_project_id, :integer
  end
end
