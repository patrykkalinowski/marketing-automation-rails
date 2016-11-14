FactoryGirl.define do
  factory :segment do
    filters [
      [
        { name: "$view",
          match: "^",
          properties: {
            page: '/messages',
          }
        }, # AND
        { name: "$view",
          match: "$",
          properties: {
            page: '1',
          }
        }
      ], # OR
      [
        { name: "$view",
          match: "!",
          properties: {
            page: '/messages/1',
          }
        }
      ], # OR
      [
        { name: "$view",
          match: "~",
          properties: {
            url: 'param=test',
          }
        }
      ], # OR
      [
        { name: "$email",
          match: "~",
          properties: {
            subject: "Example Message"
          },
        }, # AND
        {
          name: "$email",
          match: "#",
          properties: {
            to: "patryk.kalinowski"
          }
        }
      ]
    ]
  end
end
