class CreateWorkflows < ActiveRecord::Migration[7.1]
  def change
    create_table :workflows do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url
      t.string :name

      t.timestamps
    end
  end
end
