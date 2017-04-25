class CreateJoinTableReviewLike < ActiveRecord::Migration[5.0]
  def change
    create_table :review_likes do |t|
      t.integer :review_id
      t.integer :like_id
      t.index [:review_id, :like_id]
      t.index [:like_id, :review_id]
      t.index :like_id
      t.index :review_id
    end
  end
end
