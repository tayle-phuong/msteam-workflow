class CreateWorkflows < ActiveRecord::Migration[7.1]
  def change
    create_table :workflows do |t|
      t.string :url
      t.string :name

      t.timestamps
    end
  end
end
