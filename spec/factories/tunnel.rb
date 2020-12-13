FactoryBot.define do
  factory :tunnel, class: 'SSHTunnel::UI::Models::Tunnel' do

    uuid        { '117aacde-5adf-4a6d-a0f9-5acdddf4a5b9' }
    name        { 'mysql' }
    type        { 'local' }
    local_host  { '127.0.0.1' }
    local_port  { 10000 }
    remote_host { '127.0.0.1' }
    remote_port { 3306 }

    factory :tunnel_wih_parent do
      parent { build(:host) }
    end
  end
end
