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
        id: 1,
        delay: 1000
      },
      { name: "$segment",
        action: "add",
        id: 2,
        delay: 1000
      }
    ]

  end
end
