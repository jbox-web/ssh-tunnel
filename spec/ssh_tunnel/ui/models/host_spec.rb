require 'spec_helper'

RSpec.describe SSHTunnel::UI::Models::Host do

  let(:host) { FactoryBot.build(:host) }

  describe '#to_s' do
    it 'should return host name' do
      expect(host.to_s).to eq host.name
    end
  end

  describe '#to_hash' do
    it 'should return a hash of attributes' do
      expect(host.to_hash).to eq({
        uuid:    '7be48819-97bf-49fc-98af-4f7f096e1977',
        name:    'foo',
        user:    'root',
        host:    'host.example.net',
        port:    22,
        identity_file: nil,
        tunnels: [],
      })
    end

    context 'with multiple tunnels' do
      let(:host) { FactoryBot.build(:host_with_two_tunnels) }

      it 'sorts tunnels by name' do
        expect(host.to_hash).to eq({
          uuid:    '7be48819-97bf-49fc-98af-4f7f096e1977',
          name:    'foo',
          user:    'root',
          host:    'host.example.net',
          port:    22,
          identity_file: nil,
          tunnels: [
            { local_host: '127.0.0.1', local_port: 10000, name: 'aaa', remote_host: '127.0.0.1', remote_port: 3306, type: 'local', uuid: '117aacde-5adf-4a6d-a0f9-5acdddf4a5b9', auto_start: nil },
            { local_host: '127.0.0.1', local_port: 10000, name: 'zzz', remote_host: '127.0.0.1', remote_port: 3306, type: 'local', uuid: '117aacde-5adf-4a6d-a0f9-5acdddf4a5b9', auto_start: nil },
          ],
        })
      end
    end
  end

  describe '#started?' do
    context 'when tunnels are started' do
      it 'should return true' do
        host.start_tunnels!
        expect(host.started?).to be true
      end
    end

    context 'when tunnels are stopped' do
      it 'should return false' do
        expect(host.started?).to be false
      end
    end
  end

  describe '#start_tunnels!' do
    it 'should start tunnels' do
      expect(host.tunnels).to receive(:each)
      host.start_tunnels!
      expect(host.started?).to be true
    end
  end

  describe '#stop_tunnels!' do
    it 'should stop tunnels' do
      expect(host.tunnels).to receive(:each)
      host.stop_tunnels!
      expect(host.started?).to be false
    end
  end

  describe '#toggle_tunnels!' do
    context 'when tunnels are stopped' do
      it 'should start tunnels' do
         expect(host.started?).to be false

        host.toggle_tunnels!
        expect(host.started?).to be true
      end
    end

    context 'when tunnels are started' do
      it 'should stop tunnels' do
        host.start_tunnels!
        expect(host.started?).to be true

        host.toggle_tunnels!
        expect(host.started?).to be false
      end
    end
  end

  describe '#add_tunnel' do
    it 'should add tunnel to host' do
      expect(host.tunnels).to eq []
      tunnel = FactoryBot.build(:tunnel, parent: host)
      host.add_tunnel(tunnel)
      expect(host.tunnels).to eq [tunnel]
    end
  end

  describe '#remove_tunnel' do
    it 'should remove tunnel from host' do
      host = FactoryBot.build(:host_with_one_tunnel)
      expect(host.tunnels.size).to eq 1
      tunnel = host.tunnels.first
      host.remove_tunnel(tunnel)
      expect(host.tunnels).to eq []
    end
  end
end
