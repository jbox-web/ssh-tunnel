FactoryBot.define do
  factory :host, class: 'SSHTunnel::UI::Models::Host' do

    name { 'foo' }
    user { 'root' }
    host { 'host.example.net' }
    port { 22 }

    factory :host_with_tunnels do
      after(:build) do |object, _evaluator|
        object.tunnels = [build(:tunnel, parent: object)]
      end
    end
  end
end
