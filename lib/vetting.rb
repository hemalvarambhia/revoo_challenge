require 'rule/offensive_words'
require 'rule/prices'
require 'rule/repetition'
class Vetting
  def self.vet reviews
    reviews.each do |review|
      review.vet!
      violation =
        [ OffensiveWords.new, Prices.new, Repetition.new ]
        .map { |rule| rule.violation(review) }
        .detect { |violation| violation }

      if violation
        review.reject_for(violation)
      else
        review.accept!
      end
    end
  end
end
