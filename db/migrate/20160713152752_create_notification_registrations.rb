class CreateNotificationRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_registrations do |t|
      t.references :notifiable,
                   polymorphic: true,
                   index: { name: :index_pn_registrations_on_notifiable_type_and_notifiable_id },
                   null: false
      t.boolean :notify, null: false, default: true
      t.string :token, null: false
      # t.citext :platform
      # t.citext :language

      t.timestamps
    end
    add_index :notification_registrations, :token, :unique => true
  end
end
