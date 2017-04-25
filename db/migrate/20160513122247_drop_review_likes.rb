class DropReviewLikes < ActiveRecord::Migration[5.0]
  def change
    drop_table :review_likes
  end
end
