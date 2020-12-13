require 'spec_helper'

RSpec.describe SSHTunnel::UI::Models::Tunnel do

  let(:tunnel) { FactoryBot.build(:tunnel) }

  describe 'valid tunnel' do
    it 'should have a name/type/local_host/local_port/remote_host/remote_port set' do
      expect(tunnel.valid?).to be true
      expect(tunnel.errors).to eq []
    end
  end

  describe 'invalid tunnel' do
    it 'should have a name' do
      tunnel = FactoryBot.build(:tunnel, name: '')
      expect(tunnel.valid?).to be false
      expect(tunnel.errors).to eq ['name is empty']
    end

    it 'should have a type' do
      tunnel = FactoryBot.build(:tunnel, type: '')
      expect(tunnel.valid?).to be false
      expect(tunnel.errors).to eq ['type is empty']
    end

    it 'should have a local_host' do
      tunnel = FactoryBot.build(:tunnel, local_host: '')
      expect(tunnel.valid?).to be false
      expect(tunnel.errors).to eq ['local_host is empty']
    end

    it 'should have a local_port' do
      tunnel = FactoryBot.build(:tunnel, local_port: '')
      expect(tunnel.valid?).to be false
      expect(tunnel.errors).to eq ['local_port is empty']
    end

    it 'should have a remote_host' do
      tunnel = FactoryBot.build(:tunnel, remote_host: '')
      expect(tunnel.valid?).to be false
      expect(tunnel.errors).to eq ['remote_host is empty']
    end

    it 'should have a remote_port' do
      tunnel = FactoryBot.build(:tunnel, remote_port: '')
      expect(tunnel.valid?).to be false
      expect(tunnel.errors).to eq ['remote_port is empty']
    end
  end

end
