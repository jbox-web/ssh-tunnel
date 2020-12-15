require 'spec_helper'

RSpec.describe SSHTunnel do

  BASE_PATH = Pathname.new File.expand_path('..', __dir__)

  describe '.root_path' do
    it 'should return root_path path' do
      expect(described_class.root_path).to eq BASE_PATH
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

  describe '.resources_bin' do
    it 'should return resources_bin path' do
      expect(described_class.resources_bin).to eq Pathname.new('/tmp/gresources.bin')
    end
  end

  describe '.locales_path' do
    it 'should return locales_path path' do
      expect(described_class.locales_path).to eq BASE_PATH.join('config', 'locales', '*.yml')
    end
  end

  describe '.current_locale' do
    it 'should return Gtk current_locale' do
      expect {
        described_class.current_locale
      }.to_not raise_error
    end
  end

end
