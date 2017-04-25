class AddCustomerRefToAccessTokens < ActiveRecord::Migration[5.0]
  def change
    add_reference :access_tokens, :customer, index: true, foreign_key: true
  end
end
