module Validations
  def name_validation(name)
    name.is_a?(String) && name.length <= 20 && name.length >= 3
  end

  def guess_validation(guess)
    guess.to_i.is_a?(Integer) && guess.length == 4 && /\d[1-6]/.match?(guess)
  end

  def number_validation(number)
    if !(number.is_a? Array)
      number.split('').map(&:to_i)
    else
      number
    end
  end
end
