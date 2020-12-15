FactoryBot.define do
  factory :host, class: 'SSHTunnel::UI::Models::Host' do

    uuid { '7be48819-97bf-49fc-98af-4f7f096e1977' }
    name { 'foo' }
    user { 'root' }
    host { 'host.example.net' }
    port { 22 }

    factory :host_with_one_tunnel do
      after(:build) do |object, _evaluator|
        object.tunnels = [build(:tunnel, parent: object)]
      end
    end

    factory :host_with_two_tunnels do
      after(:build) do |object, _evaluator|
        object.tunnels = [build(:tunnel, name: 'zzz', parent: object), build(:tunnel, name: 'aaa', parent: object)]
      end
    end
  end
end
