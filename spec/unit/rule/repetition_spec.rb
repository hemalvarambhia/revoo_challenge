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

  describe 'when a review has words repeated three times' do
    let(:with_three_words_repeated) do
      Review.new('id' => 1, 'text' => 'This product is super super super')
    end
    
    it 'is a violation' do
      violation = Repetition.new.violation(with_three_words_repeated)
      
      expect(violation).to eq "Sorry you can't have repetition"
    end
  end
end
