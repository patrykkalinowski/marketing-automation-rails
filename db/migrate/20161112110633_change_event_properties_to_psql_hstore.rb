class ChangeEventPropertiesToPsqlHstore < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    change_column :ahoy_events, :properties, 'jsonb USING CAST("properties" AS jsonb)'
  end
end
