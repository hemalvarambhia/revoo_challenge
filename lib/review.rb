require "json"

class Review
  def self.all
    Data.read.map do |review_hash|
      new(review_hash)
    end
  end

  attr_accessor :text, :id, :vetted, :accepted, :rejection_reason
  private :vetted, :accepted

  def initialize(review_hash)
    self.text = review_hash["text"]
    self.id = review_hash["id"].to_i
    self.vetted = false
    self.accepted = false
  end

  def vetted?
    vetted
  end

  def vet!
    self.vetted = true
  end

  def accepted?
    vetted? && accepted
  end

  def accept!
    self.accepted = true
  end

  def reject!
    self.accepted = false
  end

  module Data
    def self.read
      JSON.parse(File.read(File.expand_path("./review/data.json", File.dirname(__FILE__))))["reviews"]
    end
  end
end
