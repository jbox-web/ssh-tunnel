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

end
