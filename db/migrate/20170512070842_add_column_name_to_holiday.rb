class AddColumnNameToHoliday < ActiveRecord::Migration[5.0]
  def change
  	add_column :holidays, :name, :string
  end
end
