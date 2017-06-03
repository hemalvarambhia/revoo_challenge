# encoding: UTF-8
require_relative "../spec_helper"
require "review"

describe Review do
  describe ".all" do
    it "loads 7 reviews from the datastore" do
      expect(Review.all.size).to eq 7
    end

    it "instantates instances of Review" do
      Review.all.all? { |review| expect(review).to be_a Review }
    end

    it "creates the reviews with the correct data" do
      review_text = Review.all.map(&:text)
      expect(review_text).to eq([
        "A hamster made me write this.",
        "This product was not great",
        "I love love love it!!!!!!!!!",
        "Great price, only £15 pounds, would recommend.",
        "This was a great great purchase!",
        "PHP PHP PHP Brainfuck the elderberry!!!",
        "Sometimes I talk about price, but not here!",
      ])
    end
  end

  describe "a review" do
    it "has text" do
      review = Review.new("text" => "foo bar")
      expect(review.text).to eq "foo bar"
    end

    it "has an id" do
      review = Review.new("id" => "17")
      expect(review.id).to eq 17
    end

    describe "vetting status" do
      it "has a status" do
        review = Review.new({})
        expect(review).to_not be_vetted
      end

      it "can be set" do
        review = Review.new({})
        review.vet!
        expect(review).to be_vetted
      end
    end

    describe "submission status" do
      it "has a status" do
        review = Review.new({})
        expect(review).to_not be_accepted
      end

      it "can be accepted" do
        review = Review.new({})
        review.vet!
        review.accept!
        expect(review).to be_accepted
      end

      it "can be rejected" do
        review = Review.new({})
        review.vet!
        review.accept!
        review.reject!
        expect(review).to_not be_accepted
      end

      it "is always false if not vetted" do
        review = Review.new({})
        review.accept!
        expect(review).to_not be_accepted
      end
    end

    describe "rejection reason" do
      it "is nil by default" do
        review = Review.new({})
        expect(review.rejection_reason).to be_nil
      end

      it "can be set" do
        review = Review.new({})
        review.rejection_reason = "foobah"
        expect(review.rejection_reason).to eq "foobah"
      end
    end
  end

end
