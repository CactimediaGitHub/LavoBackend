class AddBackgroundImageToProduction < ActiveRecord::Migration[5.0]
  def change
  	add_column :promotions, :background_image, :string, null: true
  end
end
