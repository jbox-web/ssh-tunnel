require 'spec_helper'

RSpec.describe SSHTunnel::UI::Forms::HostForm do

  let(:host) { FactoryBot.build(:host) }
  let(:form) { described_class.new(host) }
  let(:params) { { name: 'My Host', user: 'root', host: 'foo.bar', port: 22 } }

  describe 'form' do
    it 'has attributes' do
      expect(form.name).to be nil
      expect(form.user).to be nil
      expect(form.host).to be nil
      expect(form.port).to be nil
    end
  end

  describe '#submit' do
    it 'assigns attributes value' do
      form.submit(params)
      expect(form.name).to eq 'My Host'
      expect(form.user).to eq 'root'
      expect(form.host).to eq 'foo.bar'
      expect(form.port).to eq 22
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
      expect(host.uuid).to eq '7be48819-97bf-49fc-98af-4f7f096e1977'
      expect(host.name).to eq 'foo'
      expect(host.user).to eq 'root'
      expect(host.host).to eq 'host.example.net'
      expect(host.port).to eq "22"

      form.submit(params)
      form.save

      expect(host.uuid).to eq '7be48819-97bf-49fc-98af-4f7f096e1977'
      expect(host.name).to eq 'My Host'
      expect(host.user).to eq 'root'
      expect(host.host).to eq 'foo.bar'
      expect(host.port).to eq "22"
    end
  end

  describe 'valid form' do
    it 'should cast port to Integer' do
      params = { name: 'My Host', user: 'root', host: 'foo.bar', port: '22' }
      form.submit(params)
      expect(form.valid?).to be true
      expect(form.port).to eq 22
    end
  end

  describe 'invalid form' do
    it 'should have a name' do
      params = { name: '', user: 'root', host: 'foo.bar', port: 22 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:name)).to eq ["can't be blank"]
    end

    it 'should have a user' do
      params = { name: 'My Host', user: '', host: 'foo.bar', port: 22 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:user)).to eq ["can't be blank"]
    end

    it 'should have a host' do
      params = { name: 'My Host', user: 'root', host: '', port: 22 }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:host)).to eq ["can't be blank"]
    end

    it 'should have a port' do
      params = { name: 'My Host', user: 'root', host: 'foo.bar', port: '' }
      form.submit(params)
      expect(form.valid?).to be false
      expect(form.errors.messages_for(:port)).to eq ["can't be blank", "is not included in the list"]
    end
  end
end
