class MakeSegmentUsersUnique < ActiveRecord::Migration
  def change
    add_index :segments_users, [:segment_id, :user_id], unique: true
  end
end 
