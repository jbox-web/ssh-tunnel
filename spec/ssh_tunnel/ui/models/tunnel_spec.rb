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
        local_host: '127.0.0.1',
        local_port: 10000,
        name: 'mysql',
        remote_host: '127.0.0.1',
        remote_port: 3306,
        type: 'local',
      })
    end
  end

  describe '#command' do
    it 'should return a ssh command to run' do
      expect(tunnel.command).to eq ['/usr/bin/ssh', '-N', '-t', '-x', '-o', 'ExitOnForwardFailure=yes', '-lroot', '-L127.0.0.1:10000:127.0.0.1:3306', '-p22', 'host.example.net']
    end
  end

end
