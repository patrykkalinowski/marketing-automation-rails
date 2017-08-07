FactoryGirl.define do
  factory :segment do
    filters [
      [
        { name: "$view",
          match: "~",
          properties: {
            page: "/",
          }
        }
      ]
    ]

    factory :segment_homepage_match do
      filters [
        [
          { name: "$view",
            match: "=",
            properties: {
              page: "/"
            }
          }
        ]
      ]
    end

    factory :segment_homepage_and_params_match do
      filters [
        [
          { name: "$view",
            match: "=",
            properties: {
              page: "/"
            }
          },
          { name: "$view",
            match: "~",
            properties: {
              url: "test2"
            }
          }
        ]
      ]
    end

    factory :segment_url_params do
      filters [
        [
          { name: "$view",
            match: "~",
            properties: {
              url: "params=test"
            }
          }
        ]
      ]
    end

    factory :segment_url_empty do
      filters [
        [
          { name: "$view",
            match: "=",
            properties: {
              url: ""
            }
          }
        ]
      ]
    end

    factory :segment_custom_event do
      filters [
        [
          { name: "$custom",
            match: "~",
            properties: {
              name: "Event"
            }
          }
        ]
      ]
    end

    factory :segment_sqli do
      filters [
        [
          { name: "$user",
            match: "=",
            properties: {
              "email LIKE '%com%' OR email": ""
            }
          }
        ]
      ]
    end

  end
end
