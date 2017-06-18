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
    let(:with_one_offensive_word) do
      Review.new('id' => 2, 'text' => 'Humanities is great.')
    end

    it 'is a violation' do
      violation = offensive_words.violation(with_one_offensive_word)
      
      expect(violation).to eq "Sorry you can't use bad language"
    end
  end

  describe 'a review with multiple offensive words' do
    let(:with_many_offensive_words) do
      Review.new('id' => 3, 'text' => 'I Hate Politics and Humanities')
    end
    
    it 'is a violation' do
      violation = offensive_words.violation(with_many_offensive_words)
      
      expect(violation).to eq "Sorry you can't use bad language"
    end
  end

  describe 'a review with offensive words in lower-cased letters' do
    it 'is a violation'
  end
end
