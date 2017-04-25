class AddMatchPolicyToPromotion < ActiveRecord::Migration[5.0]
  def change
    add_column :promotions, :match_policy, :string, default: "all"
  end
end