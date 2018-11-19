FactoryBot.define do
  factory :tunnel, class: SSHTunnel::UI::Models::Tunnel do |f|
    f.initialize_with { new(parent: build(:host)) }

    f.name        { 'mysql' }
    f.type        { 'local' }
    f.local_host  { '127.0.0.1' }
    f.local_port  { '10000' }
    f.remote_host { '127.0.0.1' }
    f.remote_port { '3306' }
  end
end
