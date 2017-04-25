class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.references  :reviewable,    :polymorphic => true, null: false

      t.references  :reviewer,      :polymorphic => true, null: false
      t.string      :ip,            :limit => 24

      t.float       :rating, index: true

      t.string      :title
      t.text        :body, index: true

      t.timestamps
    end

    add_index :reviews, :reviewable_type

    add_index :reviews, [:reviewer_id, :reviewer_type]
    add_index :reviews, [:reviewable_id, :reviewable_type]
  end
end
