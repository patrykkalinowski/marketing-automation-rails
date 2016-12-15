module Ahoy
  class Message < ActiveRecord::Base
    self.table_name = "ahoy_messages"

    belongs_to :user, AhoyEmail.belongs_to.merge(polymorphic: true)

    def self.find_users(query)
      self.where.not(user_id: nil).where("#{query[:key]} #{query[:pattern_match]} ?", query[:pattern])
    end

    def self.find_users_not(query)
      self.where.not(user_id: nil).where.not("#{query[:key]} #{query[:pattern_match]} ?", query[:pattern])
    end

  end
end
