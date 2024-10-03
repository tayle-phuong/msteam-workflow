class CreateSubmits < ActiveRecord::Migration[7.1]
  def change
    create_table :submits do |t|
      t.references :user, null: false, foreign_key: true
      t.json :data

      t.timestamps
    end
  end
end
