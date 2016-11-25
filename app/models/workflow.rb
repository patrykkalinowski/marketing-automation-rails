class Workflow < ActiveRecord::Base
  serialize :filters
  serialize :actions

  has_and_belongs_to_many :users
  validates :filters, presence: true

  def build
    segment_builder = BuildSegment.new(self)
    segment_builder.call
  end

  def self.example
    name = "workflow name"
    filters = [
      [
        { name: "$view",
          match: "~",
          properties: {
            page: "/",
          }
        }
      ]
    ]
    actions = [
      { name: "$email",
        action: "send",
        id: 1
      },
      { name: "$segment",
        action: "add",
        id: 2
      }
    ]

    Workflow.create(name: name, filters: filters, actions: actions)
  end
end
