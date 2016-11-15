FactoryGirl.define do
  factory :ahoy_event, class: Ahoy::Event do
    user_id 1
    name "$view"
    properties {
      page "/"
      url "http://localhost:3000/"
      title "Marketing Automation Rails"
    }

    factory :ahoy_event_no_user do
      user_id nil
    end

    factory :ahoy_event_user_2 do
      user_id 2
    end

    factory :ahoy_event_params do
      properties {
        page "/"
        url "http://localhost:3000/?params=test"
        title "Marketing Automation Rails"
      }
    end

    factory :ahoy_event_params_user2 do
      user_id 2
      properties {
        page "/"
        url "http://localhost:3000/?params=test"
        title "Marketing Automation Rails"
      }
    end

    factory :ahoy_event_messages_index do
      properties {
        page "/messages"
        url "http://localhost:3000/messages"
        title "Messages"
      }
    end

    factory :ahoy_event_messages_show do
      properties {
        page "/messages/1"
        url "http://localhost:3000/messages/1"
        title "Messages: 1"
      }
    end

    factory :ahoy_event_name do
      name "Example Event"
    end

  end
end
