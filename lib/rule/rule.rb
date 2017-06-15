module Rule
  def violation(review)
    if violated_in?(review)
      return message
    end

    nil
  end
end
