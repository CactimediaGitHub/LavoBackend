class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :notifiable,
                   polymorphic: true,
                   index: { name: :index_notifications_on_notifiable_type_and_notifiable_id },
                   null: false
      t.string :message, null: false

      t.timestamps
    end
  end
end
