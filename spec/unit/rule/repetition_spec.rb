require 'spec_helper'
require 'review'
require 'rule/repetition'

describe Repetition do
  describe 'a review with no repetition' do
    let(:no_repetition) do
      Review.new('id' => 8, 'text' => 'What can I say - it is the best')
    end
    
    it 'is not a violation' do
      violation = Repetition.new.violation(no_repetition)
      
      expect(violation).to be_nil
    end
  end
end
