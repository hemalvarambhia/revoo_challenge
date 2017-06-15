# coding: utf-8
require 'rule/rule'
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
