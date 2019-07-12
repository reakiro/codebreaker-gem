require_relative 'validations'
require_relative 'comparing'

module Codebreaker
  class Game
    include Validations
    include Comparing

    attr_reader :secret_number, :attempts_number, :hints_number
    attr_accessor :stats

    def initialize(attempts_number, hints_number)
      @secret_number = secret_number_generate
      @attempts_number = attempts_number
      @hints_number = hints_number
      @stats = {
        name: '',
        level: '',
        attempts_used: 0,
        hints_used: 0,
        date: ''
      }
    end

    def process(input_number)
      @attempts_number -= 1
      @stats[:attempts_used] += 1
      comparing(input_number)
    end

    def lost?
      @attempts_number.zero?
    end

    def hint
      return unless @hints_number.positive?

      @hints_number -= 1
      @stats[:hints_used] += 1
      @secret_number.sample
    end

    def secret_number_generate
      (1..4).inject([]) { |number| number << rand(1..6) }
    end
  end
end
