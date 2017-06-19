# -*- coding: utf-8 -*-
require 'spec_helper'
require 'review'
require 'rule/prices'

describe Prices do
  let(:prices) { Prices.new }
  let(:expected_message) { "Sorry you can't mention the price" }

  describe 'a review with no prices quoted' do
    let(:no_prices) do
      Review.new('text' => 'No prices here!')
    end

    it 'is not a violation' do
      violation = prices.violation(no_prices)

      expect(violation).to be_nil
    end
  end

  describe 'a review with a price quoted' do
    let(:one_price_quoted) do
      Review.new('text' => 'It cost £15 - too expensive!')
    end

    it 'is a violation' do      
      violation = prices.violation(one_price_quoted)

      expect(violation).to eq expected_message
    end
  end

  describe 'a review with more than one price quoted' do
    let(:multiple_prices_quoted) do
      Review.new('text' => "It cost £15 - too expensive! It's only worth £10")
    end

    it 'is a violation' do
      violation = prices.violation(multiple_prices_quoted)

      expect(violation).to eq expected_message
    end
  end

  describe 'a review with a price quoted in a different currency' do
    it 'is a violation'
  end
end
