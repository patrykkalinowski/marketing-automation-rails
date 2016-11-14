class AddIndexToAhoyEventProperties < ActiveRecord::Migration
  def change
    add_index :ahoy_events, :properties, using: :gin
  end
end
