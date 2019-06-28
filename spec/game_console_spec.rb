require 'spec_helper'

RSpec.describe GameConsole do
  let(:console) { GameConsole.new }

  context '.start' do
    it 'calls .main_menu' do
      expect(console).to receive(:main_menu)
      console.start
    end
  end

  context '.main_menu' do
    it 'calls .registration when user picks "start"' do
      expect(console).to receive(:registration)
      allow(console).to receive(:gets).and_return('start', 'exit')
      console.main_menu
    end

    it 'calls .bye when user picks "exit"' do
    #   expect(console).to receive(:bye)
    #   allow(console).to receive(:gets).and_return('exit')
    #   console.main_menu
    end

    it 'calls .read_file with RULES when user picks "rules"' do
      expect(console).to receive(:read_file).with(GameConsole::RULES)
      allow(console).to receive(:gets).and_return('rules', 'exit')
      console.main_menu
    end

    it 'calls .read_file with STATS when user picks "rules"' do
      expect(console).to receive(:read_file).with(GameConsole::STATS)
      allow(console).to receive(:gets).and_return('stats', 'exit')
      console.main_menu
    end

    it 'outputs an error message when user types something else' do 
      allow(console).to receive(:gets).and_return('smh', 'exit')
      console.main_menu
      expect(console).to output("\n!!!!your choice is not valid!!!!").to_stdout
    end
  end

  context '.registration' do
    it 'calls .difficulty and .greeting' do
      expect(console).to receive(:difficulty)
      expect(console).to receive(:greeting)
      console.registration
    end
  end

  context '.difficulty' do
    it 'creates new game with 15 attempts and 2 hints when user picks "easy"' do
      expect(console).to receive(:new_game).with(15, 2)
      allow(console).to receive(:gets).and_return('easy', 'exit')
      console.difficulty
    end

    it 'creates new game with 10 attempts and 1 hint when user picks "medium"' do
      expect(console).to receive(:new_game).with(10, 1)
      allow(console).to receive(:gets).and_return('medium', 'exit')
      console.difficulty
    end

    it 'creates new game with 5 attempts and 1 hint when user picks "hell"' do
      expect(console).to receive(:new_game).with(5, 1)
      allow(console).to receive(:gets).and_return('hell', 'exit')
      console.difficulty
    end

    it 'calls .bye when user picks "exit"' do
      # expect(console).to receive(:bye)
      # allow(console).to receive(:gets).and_return('exit')
      # console.difficulty
    end

    it 'outputs an error message when user types something else' do
      allow(console).to receive(:gets).and_return('smh', 'exit')
      console.difficulty
      expect(console).to output("\n!!!!your choice is not valid!!!!").to_stdout
    end
  end

  context '.new_game' do
    it 'calls .greeting' do
      expect(console).to receive(:greeting)
      console.new_game(15, 2)
    end
  end

  context '.greeting' do
    let(:name) { 'darina' }

    it 'saves name if it is valid' do
      allow(console).to receive(:gets).and_return(name, 'exit')
      console.new_game(15, 2)
      expect(@game.stats[:name]).to eq(name)
    end

    it 'greets user if name is valid' do
      allow(console).to receive(:gets).and_return(name, 'exit')
      console.new_game(15, 2)
      expect(console).to output("\nhi #{name}!").to_stdout
    end

    it 'outputs an error message if name is not valid' do
      allow(console).to receive(:gets).and_return('e', 'exit')
      console.new_game(15, 2)
      expect(console).to output("\nname should be a string in a range from 3 to 20 symbols").to_stdout
    end

    it 'calls .process' do
      allow(console).to receive(:gets).and_return(name, 'exit')
      expect(console).to receive(:process)
      console.new_game(15, 2)
    end
  end
end