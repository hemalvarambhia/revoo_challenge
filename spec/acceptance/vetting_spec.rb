require "spec_helper"
require "review"

describe "I want reviews to be vetted" do
  class Vetting
    def self.vet reviews
      reviews.each do |review|
        review.vet!
        review.accept!
        uses_repetition(review) if contains_repetition?(review)
        uses_bad_language(review) if contains_bad_language?(review)
      end
    end

    private

    def self.contains_repetition? review
      word_count(review).any? { |_, count| count == 3 }
    end

    def self.uses_repetition(review)
      review.reject!
      review.rejection_reason = "Sorry you can't have repetition"
    end

    def self.word_count review
      review.text.split(' ').uniq.inject({}) do |word_count, word|
        word_count
          .merge(word => review.text.split(' ').count { |w| w == word })
      end
    end

    def self.contains_bad_language?(review)
      offensive_words = %w{hamster PHP Brainfuck elderberry}
      offensive_words.any? do |offensive_word|
        review.contains? offensive_word
      end
    end
    
    def self.uses_bad_language(review)
      review.reject!
      review.rejection_reason = "Sorry you can't use bad language"
    end
  end
  
  let(:reviews)  { Review.all }

  it "vets all reviews given" do
    Vetting.vet(reviews)
    expect(reviews).to all be_vetted
  end

  context 'vetting bad language' do
    before :each do
      Vetting.vet(reviews)
    end
    
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
      Vetting.vet(reviews)

      expect(review(2)).to be_accepted
      expect(review(5)).to be_accepted
      expect(review(7)).to be_accepted
    end
  end

  it 'rejects reviews with repetition' do
    Vetting.vet(reviews)
    
    expect(review(3)).to_not be_accepted
    expect(review(3).rejection_reason).to eq "Sorry you can't have repetition"
  end
  
  it "sets the status on the correct reviews" do
    pending "Oh and this one too"

    expect(review(3)).to_not be_accepted
    expect(review(3).rejection_reason).to eq "Sorry you can't have repetition"

    expect(review(4)).to_not be_accepted
    expect(review(4).rejection_reason).to eq "Sorry you can't mention the price"
  end

  def review(id)
    reviews.detect { |review| review.id == id }
  end
end
