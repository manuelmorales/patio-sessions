require_relative 'spec_helper'
require 'section'

describe Section do
  describe '#section' do
    it 'assigns the name' do
      subject.section(:my_section)
      expect(subject.my_section.name).to eq :my_section
    end

    it 'assigns the root' do
      subject.section(:my_section)
      expect(subject.my_section.root).to eq subject
    end

    it 'doesn\'t evaluate it at definition time' do
      target = double('target')
      expect(target).not_to receive(:a_message)

      subject.section(:my_section) do
        target.a_message
      end
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

    it 'is of the right class' do
      klass = Class.new Section
      subject = klass.new

      subject.section(:my_section)
      expect(subject.my_section).to be_a(klass)
    end

    it 'allows nesting' do
      subject.section(:first_level) do |first_level|
        first_level.section :second_level
      end
      
      expect(subject.first_level.second_level).to be_a(Section)
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

      subject.target
      subject.target
    end
  end

  describe '#eval_file' do
    it 'is executed in the scope of the object itself' do
      file = Tempfile.new 'test'
      file.write <<-FILE
        section(:my_section) do |sec|
          sec.let(:value) { object_id }
        end
      FILE
      file.close

      subject.eval_file file.path

      expect(subject.my_section.value).to eq subject.object_id
    end
  end

  describe '#inspect' do
    it 'contains class, object id and name' do
      subject.name = 'my_name'
      expect(subject.inspect).to match /#<my_name:Section:0x.*>/
    end

    it 'uses the name of the first named class in the hirarchy' do
      stub_const('MySection', Class.new(Section))
      klass = Class.new MySection
      subject = klass.new
      subject.name = 'my_name'

      expect(subject.inspect).to match /#<my_name:MySection.*>/
    end
  end

  describe 'module including' do
    let(:my_module) do
      Module.new.tap do |m|
        m::MY_CONSTANT = 37

        m.class_eval do
          def my_method
            'hi'
          end
        end
      end
    end

    let(:my_class) do
      Class.new(Section).tap do |k|
        k.send(:include, my_module)
      end
    end

    subject { my_class.new }

    it 'is accessible within sections and lets' do
      subject.section(:one) do |one|
        expect(one.my_method).to eq 'hi'

        one.let(:two) { one.my_method }
      end

      expect(subject.one.two).to eq 'hi'
    end

    it 'is accessible with file_eval' do
      file = Tempfile.new 'test'
      file.write <<-FILE
        my_method
        MY_CONSTANT

        section(:one) do |one|
          my_method
          MY_CONSTANT

          one.let(:two) do
            MY_CONSTANT
            my_method
          end
        end
      FILE
      file.close

      subject.eval_file file.path

      expect(subject.one.two).to eq 'hi'
    end
  end
end
