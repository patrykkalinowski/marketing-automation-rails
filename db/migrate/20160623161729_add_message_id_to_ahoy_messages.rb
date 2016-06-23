class AddMessageIdToAhoyMessages < ActiveRecord::Migration
  def change
    add_column :ahoy_messages, :message_id, :integer
  end
end
