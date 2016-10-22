class ChangeSegmentRulesNameToFilters < ActiveRecord::Migration
  def change
    rename_column :segments, :rules, :filters
  end
end
