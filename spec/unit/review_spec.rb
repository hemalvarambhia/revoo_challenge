# encoding: utf-8
require 'spec_helper'
require 'review'

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
    let(:review) { Review.new('id' => '17', 'text' => 'foo bar') }
    
    it "has text" do
      expect(review.text).to eq "foo bar"
    end

    it "has an id" do
      expect(review.id).to eq 17
    end

    describe 'vetting a review' do
      it 'is not vetted by default' do
        expect(review).to_not be_vetted
      end

      it 'may be vetted' do
        review.vet!
        
        expect(review).to be_vetted
      end
    end

    describe "submission status" do
      it "is not accepted by default" do
        expect(review).to_not be_accepted
      end

      context 'given it has been vetted' do
        before(:each) { review.vet! }

        it 'may be accepted' do
          review.accept!

          expect(review).to be_accepted
        end

        it 'may be rejected' do
          review.accept!
          review.reject!
          
          expect(review).to_not be_accepted
        end
      end

      context 'when it has not been vetted' do
        it 'is not accepted' do
          review.accept!
          
          expect(review).to_not be_accepted
        end
      end
    end

    describe "rejection reason" do
      it "is nil by default" do
        expect(review.rejection_reason).to be_nil
      end

      it "can be set" do
        expect { review.rejection_reason = 'foobah' }
          .to change { review.rejection_reason }.to "foobah"
      end
    end
  end
end
