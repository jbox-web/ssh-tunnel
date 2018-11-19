FactoryBot.define do
  factory :host, class: SSHTunnel::UI::Models::Host do |f|
    f.name { 'foo' }
    f.user { 'root' }
    f.host { 'host.example.net' }
    f.port { '22' }
  end
end
