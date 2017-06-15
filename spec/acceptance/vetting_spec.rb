# coding: utf-8
require "spec_helper"
require 'rule/rule'
require 'rule/prices'
require 'rule/repetition'
require 'rule/bad_language'
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
