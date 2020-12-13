require 'spec_helper'

RSpec.describe SSHTunnel::UI::Models::Host do

  let(:host) { FactoryBot.build(:host) }

  describe 'valid host' do
    it 'should have a name/user/host/port set' do
      expect(host.valid?).to be true
      expect(host.errors).to eq []
    end
  end

  describe 'invalid host' do
    it 'should have a name' do
      host = FactoryBot.build(:host, name: '')
      expect(host.valid?).to be false
      expect(host.errors).to eq ['name is empty']
    end

    it 'should have a user' do
      host = FactoryBot.build(:host, user: '')
      expect(host.valid?).to be false
      expect(host.errors).to eq ['user is empty']
    end

    it 'should have a host' do
      host = FactoryBot.build(:host, host: '')
      expect(host.valid?).to be false
      expect(host.errors).to eq ['host is empty']
    end

    it 'should have a port' do
      host = FactoryBot.build(:host, port: '')
      expect(host.valid?).to be false
      expect(host.errors).to eq ['port is empty']
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

  describe '#to_s' do
    it 'should return host name' do
      expect(host.to_s).to eq host.name
    end
  end

  describe '#to_hash' do
    it 'should return a hash of attributes' do
      expect(host.to_hash).to eq({
        name:    'foo',
        user:    'root',
        host:    'host.example.net',
        port:    '22',
        tunnels: [],
      })
    end
  end

  describe '#start_tunnels!' do
    it 'should start tunnels' do
      expect(host.tunnels).to receive(:map)
      host.start_tunnels!
      expect(host.started?).to be true
    end
  end

  describe '#stop_tunnels!' do
    it 'should stop tunnels' do
      expect(host.tunnels).to receive(:map)
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

end
