require 'spec_helper'

describe NogizakaBlog do
  describe 'Instance' do
    it do
      nogi = NogizakaBlog::Amazing.new(201508)
      expect(nogi).to be_a(Enumerable)
    end
  end

  describe 'Extensions to String' do
    it 'to_kanji' do
      expect('manatsu.akimoto'.to_kanji).to eq('秋元真夏')
    end
  end

  describe 'Extensions to Array' do
    using NogizakaBlog::Extensions if RUBY_VERSION >= '2.1.0'

    it 'sum' do
      ary = %w(1 2 3 4 5)
      expect(ary.sum).to eq(15)
    end
  end
end
