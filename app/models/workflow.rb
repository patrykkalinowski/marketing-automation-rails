class Workflow < ActiveRecord::Base
  serialize :filters
  serialize :actions

  has_and_belongs_to_many :users
  validates :filters, presence: true

  def build
    segment_builder = BuildWorkflow.new(self)
    segment_builder.call
  end

  def launch
    self.users.each do |user|
      enroll = EnrollUserInWorkflow.new({user: user, workflow: self})
      enroll.call
    end
  end

  def self.example
    name = "workflow name"
    filters = [
      [
        { name: "$segment",
          match: "=",
          properties: {
            id: "1",
          }
        }
      ]
    ]
    actions = [
      { name: "$email",
        action: "send",
        id: 1,
        delay: 300
      },
      { name: "$email",
        action: "send",
        id: 2,
        delay: 7200
      },
      { name: "$email",
        action: "send",
        id: 3,
        delay: 259200
      }
    ]

    Workflow.create(name: name, filters: filters, actions: actions)
  end
end
