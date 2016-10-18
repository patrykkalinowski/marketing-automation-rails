class AddCreatedAtToSegmentsUsers < ActiveRecord::Migration
  def change
    add_column :segments_users, :created_at, :datetime
  end
end
