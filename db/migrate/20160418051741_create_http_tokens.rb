class CreateHttpTokens < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :http_tokens do |t|
      t.uuid :key, null: false, default: -> { 'gen_random_uuid()' }
      t.references :tokenable, polymorphic: true, index: true #, null: false

      t.timestamps
    end
    add_index :http_tokens, :key, :unique => true
  end
end
