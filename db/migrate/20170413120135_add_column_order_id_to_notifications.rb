class AddColumnOrderIdToNotifications < ActiveRecord::Migration[5.0]
  def change
  	add_column :notifications, :order_id, :integer
  end
end
