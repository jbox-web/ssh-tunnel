require 'spec_helper'

describe SSHTunnel do

  BASE_PATH      = Pathname.new File.expand_path('..', __dir__)
  USER_DATA_PATH = Pathname.new File.expand_path('~/.config/ssh-tunnel')

  describe '.base_path' do
    it 'should return base_path path' do
      expect(described_class.base_path).to eq BASE_PATH
    end
  end

  describe '.resources_path' do
    it 'should return resources_path path' do
      expect(described_class.resources_path).to eq BASE_PATH.join('resources')
    end
  end

  describe '.resources_xml' do
    it 'should return resources_xml path' do
      expect(described_class.resources_xml).to eq BASE_PATH.join('resources').join('gresources.xml')
    end
  end

  describe '.user_data_path' do
    it 'should return user_data_path path' do
      expect(described_class.user_data_path).to eq Pathname.new(File.expand_path('~/.config/ssh-tunnel'))
    end
  end

  describe '.tmp_path' do
    it 'should return tmp_path path' do
      expect(described_class.tmp_path).to eq USER_DATA_PATH.join('tmp')
    end
  end

  describe '.resources_bin' do
    it 'should return resources_bin path' do
      expect(described_class.resources_bin).to eq USER_DATA_PATH.join('tmp').join('gresource.bin')
    end
  end

  describe '.locales_path' do
    it 'should return locales_path path' do
      expect(described_class.locales_path).to eq USER_DATA_PATH.join('locales')
    end
  end

  describe '.config_file_path' do
    it 'should return config_file_path path' do
      expect(described_class.config_file_path).to eq USER_DATA_PATH.join('config.yml')
    end
  end

  # describe '.config' do
  #   it 'should return do path' do
  #     expect(described_class.config).to eq ''
  #   end
  # end

  # describe '.load_config' do
  #   it 'should return load_config path' do
  #     expect(described_class.load_config).to eq ''
  #   end
  # end

end
