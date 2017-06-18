require 'rule/rule'
class Repetition
  include Rule

  private

  def violated_in? review
    word_count(review).any? { |_, count| count >= 3 }
  end

  def word_count(review)
    words = review.words
    words.uniq.inject({}) do |word_count, word|
      word_count.merge(word => words.count { |w| w == word })
    end
  end

  def message
    "Sorry you can't have repetition"
  end
end
