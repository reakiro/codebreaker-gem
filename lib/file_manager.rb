module FileManager
  def save_score(file_name)
    puts "if you want to save your score type 'yes'\notherwise type anything else"
    answer = gets.chomp
    return unless answer == 'yes'

    line = "#{@game.stats[:name]}: #{@game.stats[:attempts_used]} attempts used; "
    line += "#{@game.stats[:hints_used]} hints used"
    File.open(File.join(__dir__, file_name), 'a') { |file| file.puts line }
  end

  def read_file(file_name)
    puts "\n"
    text = File.open(File.join(__dir__, file_name)).read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      print line
    end
  end
end
