require 'spec_helper'

RSpec.describe SSHTunnel::UI::Models::Tunnel do

  let(:tunnel) { FactoryBot.build(:tunnel_wih_parent) }

  describe '#to_s' do
    it 'should return tunnel name' do
      expect(tunnel.to_s).to eq 'foo - mysql'
    end
  end

  describe '#to_hash' do
    it 'should return a hash of attributes' do
      expect(tunnel.to_hash).to eq({
        uuid:        '117aacde-5adf-4a6d-a0f9-5acdddf4a5b9',
        name:        'mysql',
        type:        'local',
        local_host:  '127.0.0.1',
        local_port:  10000,
        remote_host: '127.0.0.1',
        remote_port: 3306,
        auto_start:  nil,
      })
    end
  end

  describe '#command' do
    it 'should return a ssh command to run' do
      expect(tunnel.command).to eq ['/usr/bin/ssh', '-N', '-t', '-x', '-o', 'ExitOnForwardFailure=yes', '-lroot', '-L127.0.0.1:10000:127.0.0.1:3306', '-p22', 'host.example.net']
    end

    context 'when identity_file is set' do
      let(:host) { FactoryBot.build(:host, identity_file: '/tmp/foo.key') }
      let(:tunnel) { FactoryBot.build(:tunnel, parent: host) }

      it 'should return a ssh command to run' do
        expect(tunnel.command).to eq ['/usr/bin/ssh', '-N', '-t', '-x', '-o', 'ExitOnForwardFailure=yes', '-lroot', '-L127.0.0.1:10000:127.0.0.1:3306', '-p22', '-i/tmp/foo.key', 'host.example.net']
      end
    end
  end

end
