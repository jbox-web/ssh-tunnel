require 'spec_helper'

RSpec.describe SSHTunnel::UI::Forms::TunnelForm do

  let(:tunnel) { FactoryBot.build(:tunnel_wih_parent) }
  let(:form) { described_class.new(tunnel) }
  let(:params) { { name: 'My Tunnel', type: 'remote', local_host: '127.0.0.1', local_port: 5000, remote_host: '127.0.0.1', remote_port: 6379 } }

  describe 'form' do
    it 'has attributes' do
      expect(form.name).to be nil
      expect(form.type).to be nil
      expect(form.local_host).to be nil
      expect(form.local_port).to be nil
      expect(form.remote_host).to be nil
      expect(form.remote_port).to be nil
    end
  end

  describe '#submit' do
    it 'assigns attributes value' do
      form.submit(params)
      expect(form.name).to eq 'My Tunnel'
      expect(form.type).to eq 'remote'
      expect(form.local_host).to eq '127.0.0.1'
      expect(form.local_port).to eq 5000
      expect(form.remote_host).to eq '127.0.0.1'
      expect(form.remote_port).to eq 6379
    end
  end

  describe '#valid?' do
    context 'with valid params' do
      it 'returns true' do
        form.submit(params)
        expect(form.valid?).to be true
      end
    end

    context 'with invalid params' do
      let(:params) { {} }

      it 'returns false' do
        form.submit(params)
        expect(form.valid?).to be false
      end
    end
  end

  describe '#save' do
    it 'should save value on model' do
      expect(tunnel.uuid).to eq '117aacde-5adf-4a6d-a0f9-5acdddf4a5b9'
      expect(tunnel.name).to eq 'mysql'
      expect(tunnel.type).to eq 'local'
      expect(tunnel.local_host).to eq '127.0.0.1'
      expect(tunnel.local_port).to eq "10000"
      expect(tunnel.remote_host).to eq '127.0.0.1'
      expect(tunnel.remote_port).to eq "3306"

      form.submit(params)
      form.save

      expect(tunnel.uuid).to eq '117aacde-5adf-4a6d-a0f9-5acdddf4a5b9'
      expect(tunnel.name).to eq 'My Tunnel'
      expect(tunnel.type).to eq 'remote'
      expect(tunnel.local_host).to eq '127.0.0.1'
      expect(tunnel.local_port).to eq "5000"
      expect(tunnel.remote_host).to eq '127.0.0.1'
      expect(tunnel.remote_port).to eq "6379"
    end
  end

  describe 'valid form' do
    it 'should cast local_port to Integer' do
      params = { name: 'My Tunnel', type: 'local', local_host: '127.0.0.1', local_port: '5000', remote_host: '127.0.0.1', remote_port: 3306 }
      form.submit(params)
      expect(form.valid?).to be true
      expect(form.local_port).to eq 5000
    end

    it 'should cast remote_port to Integer' do
      params = { name: 'My Tunnel', type: 'local', local_host: '127.0.0.1', local_port: 5000, remote_host: '127.0.0.1', remote_port: '3306' }
      form.submit(params)
      expect(form.valid?).to be true
      expect(form.remote_port).to eq 3306
    end
  end

  describe 'invalid form' do
    it 'should have a name' do
      params = { name: '', type: 'local', local_host: '127.0.0.1', local_port: 5000, remote_host: '127.0.0.1', remote_port: 3306 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:name)).to eq ["can't be blank"]
    end

    it 'should have a type' do
      params = { name: 'My Tunnel', type: '', local_host: '127.0.0.1', local_port: 5000, remote_host: '127.0.0.1', remote_port: 3306 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:type)).to eq ["can't be blank"]
    end

    it 'should have a local_host' do
      params = { name: 'My Tunnel', type: 'local', local_host: '', local_port: 5000, remote_host: '127.0.0.1', remote_port: 3306 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:local_host)).to eq ["can't be blank"]
    end

    it 'should have a local_port' do
      params = { name: 'My Tunnel', type: 'local', local_host: '127.0.0.1', local_port: '', remote_host: '127.0.0.1', remote_port: 3306 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:local_port)).to eq ["can't be blank", "is not included in the list"]
    end

    it 'should have a remote_host' do
      params = { name: 'My Tunnel', type: 'local', local_host: '127.0.0.1', local_port: 5000, remote_host: '', remote_port: 3306 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:remote_host)).to eq ["can't be blank"]
    end

    it 'should have a remote_port' do
      params = { name: 'My Tunnel', type: 'local', local_host: '127.0.0.1', local_port: 5000, remote_host: '127.0.0.1', remote_port: '' }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:remote_port)).to eq ["can't be blank", "is not included in the list"]
    end
  end
end
