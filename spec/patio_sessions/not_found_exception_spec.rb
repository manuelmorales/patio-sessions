require_relative '../spec_helper'

RSpec.describe 'exceptions' do
  def subject
    patio_app.exceptions.not_found.get_obj
  end

  describe 'not_found' do
    it 'accepts a message' do
      exception = subject.new 'This is a test'
      expect(exception.message).to eq 'This is a test'
    end

    it 'can be raised and rescued' do
      exception = subject.new 'This is a test'
      expect(milestone = Object.new).to receive(:reached) # To make use the execption was raised


      begin
        raise exception
      rescue subject => e
        milestone.reached
        expect(e).to be_a Exception
      end
    end

    it 'accepts an id' do
      exception = subject.new 'This is a test', id: 37
      expect(exception.id).to eq 37
    end
  end
end
