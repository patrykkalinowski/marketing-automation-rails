class CreateJoinTableWorkflowsUsers < ActiveRecord::Migration
  def change
    create_join_table :workflows, :users
  end
end
