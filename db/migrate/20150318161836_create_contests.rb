class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.integer :count
      t.datetime :from_date
      t.datetime :to_date
      t.text :information

      t.timestamps null: false
    end
  end
end
