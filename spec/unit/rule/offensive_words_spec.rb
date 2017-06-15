require 'spec_helper'
require 'rule/offensive_words'

describe OffensiveWords do
  describe 'a review with no offensive words' do
    it 'is not a violation'
  end
  
  describe 'a review with one offensive word' do
    it 'is a violation'
  end

  describe 'a review with multiple offensive words' do
    it 'is a violation'
  end
end
