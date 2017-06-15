require 'spec_helper'
require 'review'
require 'rule/offensive_words'

describe OffensiveWords do
  let(:list) { %w{Hate Politics Humanities} }
  subject(:offensive_words) do
    OffensiveWords.new(list)
  end
  
  describe 'a review with no offensive words' do
    let(:without_offensive_words) do
      Review.new('id' => 1, 'text' => 'Great product, really useful.')
    end
      
    it 'is not a violation' do
      violation = offensive_words.violation(without_offensive_words)
      
      expect(violation).to be_nil
    end
  end
  
  describe 'a review with one offensive word' do
    it 'is a violation'
  end

  describe 'a review with multiple offensive words' do
    it 'is a violation'
  end
end
