FactoryGirl.define do
  factory :workflow do
    name "workflow name"
    filters [
      [
        { name: "$segment",
          match: "=",
          properties: {
            id: 1,
          }
        }
      ]
    ]
    actions [
      { name: "$email",
        action: "send",
        id: 1
      },
      { name: "$segment",
        action: "add",
        id: 2
      }
    ]

  end
end
