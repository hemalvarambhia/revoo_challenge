require 'rule/rule'
class OffensiveWords
  include Rule

  attr_reader :offensive_words
      
  def initialize(offensive_words = %w{hamster PHP Brainfuck elderberry})
    @offensive_words = offensive_words
  end
      
  private

  def violated_in?(review)
    offensive_words.any? do |offensive_word|
      review.contains? offensive_word
    end
  end

  def message
    "Sorry you can't use bad language"
  end
end
