FactoryGirl.define do
  factory :segment do
    filters [
      [
        { name: "$view",
          match: "~",
          properties: {
            page: '/',
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
            match: "empty",
            properties: {
              url: ""
            }
          }
        ]
      ]
    end

  end
end
