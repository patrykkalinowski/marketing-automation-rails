module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user

    def self.find_users(query)
      sql_query = "properties->>'#{query[:key]}' #{query[:pattern_match]} ?"
      self.where.not(user_id: nil).where(sql_query, query[:pattern])
    end

    def self.find_users_not(query)
      sql_query = "properties->>'#{query[:key]}' #{query[:pattern_match]} ?"
      self.where.not(user_id: nil).where.not(sql_query, query[:pattern])
    end

    def self.find_users_custom(query)
      sql_query = "name #{query[:pattern_match]} ?"
      self.where.not(user_id: nil).where(sql_query, query[:pattern])
    end

    def self.find_users_custom_not(query)
      sql_query = "name #{query[:pattern_match]} ?"
      self.where.not(user_id: nil).where.not(sql_query, query[:pattern])
    end
  end
end
