require_relative 'game_logic'
require_relative 'validations'

class GameConsole
  RULES = 'rules.txt'.freeze
  STATS = 'stats.txt'.freeze

  @@stats_hash = {
    name: '',
    attempts_used: 0,
    hints_used: 0
  }

  include Validations

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
    greeting
    difficulty
  end

  def process
    loop do
      puts "\nplease enter your guess\n(for a hint type 'hint' or 'exit' to leave)"
      guess = gets.chomp
      choice(guess) do
        game_loop(guess)
        break
      end
    end
  end

  def game_loop(guess)
    until @game.attempts_number.negative?
      result = @game.comparing(@game.secret_number, guess)
      puts result
      if result == '++++'
        conclusion(result)
      else
        puts "try again. you have #{@game.attempts_number} attempts left."
        guess = gets.chomp
        choice(guess) do
          @game.attempts_number -= 1
          @@stats_hash[:attempts_used] += 1
        end
      end
      conclusion(result) if @game.attempts_number.zero?
    end
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
    if @game.hints_number != 0
      puts @game.secret_number.sample
      @game.hints_number -= 1
      @@stats_hash[:hints_used] += 1
    else
      puts 'you have no hints left :('
    end
  end

  def read_file(file_name)
    puts "\n"
    text = File.open(file_name).read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      print line
    end
  end

  def conclusion(result)
    if result == '++++'
      puts 'you won!!!'
      save_score
    else
      puts 'you lost :('
      puts "secret number is #{@game.secret_number.join('')}"
    end
    main_menu
  end

  def save_score
    puts "if you want to save your score type 'yes'\notherwise type anything else"
    answer = gets.chomp
    return unless answer != 'yes'

    line = "#{@@stats_hash[:name]}: #{@@stats_hash[:attempts_used]} attempts used; "
    line += "#{@@stats_hash[:hints_used]} hints used"
    File.open('stats.txt', 'a') { |file| file.puts line }
  end

  def greeting
    loop do
      puts "\nplease enter your name"
      name = gets.chomp
      if name != 'exit'
        if name_validation(name)
          @@stats_hash[:name] = name
          puts "\nhi #{name}!"
          break
        else
          puts "\nname should be a string in a range from 3 to 20 symbols"
        end
      else
        bye
      end
    end
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
    @@stats_hash[:attempts_used] = 0
    @@stats_hash[:hints_used] = 0
    process
  end
end
