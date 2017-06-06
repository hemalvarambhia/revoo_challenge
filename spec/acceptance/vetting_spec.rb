require "spec_helper"
require "review"

describe "I want reviews to be vetted" do
  class Vetting
    def self.vet reviews
      reviews.each &:vet!
    end
  end
  
  let(:reviews)  { Review.all }

  it "vets all reviews given" do
    Vetting.vet(reviews)
    expect(reviews).to all be_vetted
  end

  it "sets the status on the correct reviews" do
    pending "Oh and this one too"

    Vetting.vet(reviews)

    expect(review(1)).to_not be_accepted
    expect(review(1).rejection_reason).to eq "Sorry you can't use bad language"

    expect(review(2)).to be_accepted

    expect(review(3)).to_not be_accepted
    expect(review(3).rejection_reason).to eq "Sorry you can't have repetition"

    expect(review(4)).to_not be_accepted
    expect(review(4).rejection_reason).to eq "Sorry you can't mention the price"

    expect(review(5)).to be_accepted

    expect(review(6)).to_not be_accepted
    expect(review(6).rejection_reason).to eq "Sorry you can't use bad language"

    expect(review(7)).to be_accepted
  end

  def review(id)
    reviews.detect { |review| review.id == id }
  end
end
