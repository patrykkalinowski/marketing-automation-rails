class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.text :rules

      t.timestamps null: false
    end
  end
end
