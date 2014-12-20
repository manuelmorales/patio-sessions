require_relative 'spec_helper'
require 'hash_section'

describe HashSection do
  subject { HashSection.new name: 'subject' }

  describe '#section' do
    it 'provides sections' do
      subject.section(:my_section)
      expect{ subject.my_section }.not_to raise_error
      expect(subject.respond_to? :my_section).to eq true
    end

    it 'assigns the name' do
      subject.section(:my_section)
      expect(subject.my_section.name).to eq :my_section
    end

    it 'assigns the parent' do
      subject.section(:my_section){|s| s.section(:my_sub_section) }
      expect(subject.my_section.my_sub_section.parent).to eq subject.my_section
    end

    it 'memoizes the result' do
      target = double('target')
      expect(target).to receive(:a_message).once

      subject.section(:my_section) do
        target.a_message
      end

      subject.my_section
      subject.my_section
    end

    it 'allows nesting' do
      subject.section(:first_level) do |first_level|
        first_level.section :second_level
      end
      
      expect(subject.first_level.second_level).to be_a(HashSection)
    end

    it 'doesn\'t overwrite if nesting an already existent' do
      subject.section(:a){|s| s.define_singleton_method(:b){ 2 } }
      subject.section(:a){|s| s.define_singleton_method(:c){ 3 } }
      expect(subject.a.b).to eq 2
      expect(subject.a.c).to eq 3
    end
  end

  describe '#root' do
    it 'is the parent with no parent' do
      subject.section(:a){|s| s.section(:b) }
      expect(subject.a.b.root).to eq subject
    end
  end

  describe '#ancestors' do
    it 'is the the list of parents' do
      subject.section(:a){|s| s.section(:b) }
      expect(subject.a.b.ancestors).to eq [subject, subject.a]
    end
  end

  describe '#path' do
    it 'is the the list of parents and itself' do
      subject.section(:a){|s| s.section(:b) }
      expect(subject.a.b.path).to eq [subject, subject.a, subject.a.b]
    end
  end

  describe '#let' do
    it 'doesn\'t evaluate it at definition time' do
      target = double('target')
      expect(target).not_to receive(:a_message)

      subject.let(:target) do
        target.a_message
        target
      end
    end

    it 'memoizes the result' do
      target = double('target')
      expect(target).to receive(:a_message).once

      subject.let(:target) do
        target.a_message
        target
      end

      subject.target.to_s
      subject.target.to_s
    end
  end
end
