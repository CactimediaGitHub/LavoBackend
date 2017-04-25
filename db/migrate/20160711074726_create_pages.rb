class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.citext :nick,    null: false
      t.string :title,   null: false, default: ''
      t.text   :body,    null: false, default: ''

      t.timestamps
    end

    # reversible do |dir|
    #   dir.up do
    #     execute <<-SQL
    #       create unique index index_pages_on_lower_nick on pages (lower((nick)::text));
    #     SQL
    #   end
    #   dir.down do
    #     execute <<-SQL
    #       drop index index_pages_on_lower_nick;
    #     SQL
    #   end
    # end
  end
end
