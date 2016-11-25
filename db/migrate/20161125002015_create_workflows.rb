class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.string :name
      t.text :filters
      t.text :actions
      t.timestamps null: false
    end
  end
end
