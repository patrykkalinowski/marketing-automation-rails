class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :from_name
      t.string :from_email
      t.string :subject
      t.text :content

      t.timestamps null: false
    end
  end
end
