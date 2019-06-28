module Comparing

  def comparing(input_number)
    input_number = number_validation(input_number)
    result = ''
    matched_s_indexes = []
    matched_i_indexes = []
    input_number.each_with_index do |i_number, i_index|
      @secret_number.each_with_index do |s_number, s_index|
        next unless s_number == i_number && s_index == i_index

        result.prepend('+')
        matched_i_indexes << i_index
        matched_s_indexes << s_index
      end
      @secret_number.each_with_index do |s_number, s_index|
        next unless s_number == i_number && s_index != i_index &&
                    !(matched_i_indexes.include? i_index) && !(matched_s_indexes.include? s_index)

        result += '-'
        matched_s_indexes << s_index
      end
    end
    result
  end
end