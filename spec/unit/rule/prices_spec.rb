require 'spec_helper'
require 'review'
require 'rule/prices'

describe Prices do
  describe 'a review with no prices quoted' do
    it 'is not a violation' do
      violation = Prices.new.violation(Review.new('text' => 'No prices here!'))

      expect(violation).to be_nil
    end
  end

  describe 'a review with a price quoted' do
    it 'is a violation'
  end

  describe 'a review with more than one price quoted' do
    it 'is a violation'
  end

  describe 'a review with a price quoted in a different currency' do
    it 'is a violation'
  end
end
