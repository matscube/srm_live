class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :contest_id
      t.text :information

      t.timestamps null: false
    end
  end
end
