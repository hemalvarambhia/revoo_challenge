# coding: utf-8
require "spec_helper"
require "review"

describe "I want reviews to be vetted" do
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

    private

    module Rule
      def violation(review)
        if violated_in?(review)
          return message
        end

        nil
      end
    end

    class Prices
      include Rule

      private

      def violated_in?(review)
        review.text.scan(/£\d+/).any?
      end

      def message
        "Sorry you can't mention the price"
      end
    end

    class Repetition
      include Rule

      private

      def violated_in? review
        word_count(review).any? { |_, count| count == 3 }
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
  end
  
  let(:reviews)  { Review.all }
  before(:each) { Vetting.vet(reviews) }

  it "vets all reviews given" do
    expect(reviews).to all be_vetted
  end

  context 'vetting bad language' do
    it "rejects review containing the word 'hamster'" do
      expect(review(1)).to_not be_accepted
      expect(review(1).rejection_reason)
        .to eq "Sorry you can't use bad language"
    end

    it "rejects reviews containing the words 'PHP', 'Brainfuck' and 'elderberry'"do
      expect(review(6)).to_not be_accepted
      expect(review(6).rejection_reason)
        .to eq "Sorry you can't use bad language"
    end
  end

  context 'acceptable reviews' do
    it 'accepts reviews without bad language' do
      expect(review(2)).to be_accepted
      expect(review(5)).to be_accepted
      expect(review(7)).to be_accepted
    end
  end

  it 'rejects reviews with repetition' do
    expect(review(3)).to_not be_accepted
    expect(review(3).rejection_reason).to eq "Sorry you can't have repetition"
  end
  
  it 'rejects review that quote prices' do
    expect(review(4)).to_not be_accepted
    expect(review(4).rejection_reason).to eq "Sorry you can't mention the price"
  end

  def review(id)
    reviews.detect { |review| review.id == id }
  end
end
