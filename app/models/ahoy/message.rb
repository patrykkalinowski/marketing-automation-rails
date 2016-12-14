module Ahoy
  class Message < ActiveRecord::Base
    self.table_name = "ahoy_messages"

    belongs_to :user, AhoyEmail.belongs_to.merge(polymorphic: true)

    def self.find_users(params)
      self.where.not(user_id: nil).where("#{params[:key]} #{params[:pattern_match]} ?", params[:pattern])
    end

    def self.find_users_not(params)
      self.where.not(user_id: nil).where.not("#{params[:key]} #{params[:pattern_match]} ?", params[:pattern])
    end

  end
end
