class DropAccessTokens < ActiveRecord::Migration[5.0]
  def change
    drop_table :access_tokens
  end
end
