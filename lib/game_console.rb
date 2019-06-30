require_relative 'game'
require_relative 'validations'
require_relative 'file_manager'

class GameConsole
  RULES = 'rules.txt'.freeze
  STATS = 'stats.txt'.freeze

  include Validations
  include FileManager

  def start
    puts '*' * 50
    puts '*' * 13 + ' welcome to Codebreaker ' + '*' * 13
    puts '*' * 50
    main_menu
  end

  def main_menu
    loop do
      puts "\nplease select from options below:\n\nstart\nrules\nstats\nexit\n"
      response = gets.chomp
      case response
      when 'start'
        registration
        break
      when 'rules'
        read_file(RULES)
      when 'stats'
        read_file(STATS)
      when 'exit'
        bye
      else
        puts "\n" + '!!!!your choice is not valid!!!!'
      end
    end
  end

  def registration
    difficulty
    greeting
  end

  def process
    result = ''
    until @game.lost? || result == '++++'
      puts "\nplease enter your guess\n(for a hint type 'hint' or 'exit' to leave)"
      guess = gets.chomp
      choice(guess) do
        result = @game.process(guess)
        puts result
        puts "try again. you have #{@game.attempts_number} attempts left." if result != '++++'
      end
    end
    conclusion(result)
  end

  def choice(guess, &block)
    case guess
    when 'hint'
      hint
    when 'exit'
      bye
    else
      if guess_validation(guess)
        block.call
      else
        puts "\n" + '!!!!your guess is not valid!!!!'
      end
    end
  end

  def bye
    puts 'farewell my friend'
    exit
  end

  def hint
    puts @game.hint || 'you have no hints left'
  end

  def conclusion(result)
    if result == '++++'
      puts 'you won!!!'
      save_score(STATS)
    else
      puts 'you lost :('
      puts "secret number is #{@game.secret_number.join('')}"
    end
    main_menu
  end

  def greeting
    loop do
      puts "\nplease enter your name"
      name = gets.chomp
      if name != 'exit'
        if name_validation(name)
          @game.stats[:name] = name
          puts "\nhi #{name}!"
          break
        else
          puts "\nname should be a string in a range from 3 to 20 symbols"
        end
      else
        bye
      end
    end
    process
  end

  def difficulty
    loop do
      puts "\nplease choose the difficulty from the following:\n" +
           + "easy\nmedium\nhell"
      difficulty = gets.chomp
      case difficulty
      when 'easy'
        new_game(15, 2)
        break
      when 'medium'
        new_game(10, 1)
        break
      when 'hell'
        new_game(5, 1)
        break
      when 'exit'
        bye
      else
        puts "\n" + '!!!!your choice is not valid!!!!'
      end
    end
  end

  def new_game(attempts, hints)
    @game = Game.new(attempts, hints)
    greeting
  end
end
