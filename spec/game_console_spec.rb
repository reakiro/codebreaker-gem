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
      expect { console.main_menu }.to raise_error(SystemExit)
    end

    it 'calls .bye when user picks "exit"' do
      allow(console).to receive(:gets).and_return('exit')
      expect { console.main_menu }.to raise_error(SystemExit)
    end

    it 'calls .read_file with RULES when user picks "rules"' do
      expect(console).to receive(:read_file).with(GameConsole::RULES)
      allow(console).to receive(:gets).and_return('rules', 'exit')
      expect { console.main_menu }.to raise_error(SystemExit)
    end

    it 'calls .read_file with STATS when user picks "rules"' do
      expect(console).to receive(:read_file).with(GameConsole::STATS)
      allow(console).to receive(:gets).and_return('stats', 'exit')
      expect { console.main_menu }.to raise_error(SystemExit)
    end

    it 'outputs an error message when user types something else' do
      allow(console).to receive(:gets).and_return('smh', 'exit')
      expect { console.main_menu }.to output(/your choice is not valid/).to_stdout.and raise_error(SystemExit)
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
    before do
      allow(console).to receive(:loop).and_yield
    end

    it 'creates new game with 15 attempts and 2 hints when user picks "easy"' do
      expect(console).to receive(:new_game).with(15, 2)
      allow(console).to receive(:gets).and_return('easy')
      console.difficulty
    end

    it 'creates new game with 10 attempts and 1 hint when user picks "medium"' do
      expect(console).to receive(:new_game).with(10, 1)
      allow(console).to receive(:gets).and_return('medium')
      console.difficulty
    end

    it 'creates new game with 5 attempts and 1 hint when user picks "hell"' do
      expect(console).to receive(:new_game).with(5, 1)
      allow(console).to receive(:gets).and_return('hell')
      console.difficulty
    end

    it 'calls .bye when user picks "exit"' do
      allow(console).to receive(:gets).and_return('exit')
      expect(console).to receive(:bye)
      console.difficulty
    end

    it 'outputs an error message when user types something else' do
      allow(console).to receive(:gets).and_return('smh', 'exit')
      expect { console.difficulty }.to output(/\n!!!!your choice is not valid!!!!/).to_stdout
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

    before do
      allow(console).to receive(:loop).and_yield
      console.instance_variable_set(:@game, Game.new(15, 2))
    end

    it 'saves name if it is valid' do
      allow(console).to receive(:gets).and_return(name)
      expect(console).to receive(:process)
      console.greeting
      expect(console.instance_variable_get(:@game).stats[:name]).to eq(name)
    end

    it 'greets user if name is valid' do
      allow(console).to receive(:gets).and_return(name)
      expect(console).to receive(:process)
      expect { console.new_game(15, 2) }.to output(/\nhi #{name}!/).to_stdout
    end

    it 'outputs an error message if name is not valid' do
      allow(console).to receive(:gets).and_return('e')
      expect(console).to receive(:process)
      expect { console.greeting }.to output(/\nname should be a string in a range from 3 to 20 symbols/).to_stdout
    end

    it 'calls .process' do
      allow(console).to receive(:gets).and_return(name)
      expect(console).to receive(:process)
      console.greeting
    end
  end

  context '.process' do
    let(:name) { 'darina' }
    let(:game) { console.instance_variable_set(:@game, Game.new(5, 2)) }

    before do
      game
      allow(game).to receive(:lost?).and_return(false, true)
    end

    it 'calls @game.process with guess if guess is valid' do
      allow(console).to receive(:gets).and_return('1234', 'exit')
      expect(game).to receive(:process).with('1234')
      expect { console.process }.to raise_error(SystemExit)
    end

    it 'calls .hint if user picks hint' do
      allow(console).to receive(:gets).and_return('hint', 'exit')
      expect(console).to receive(:hint)
      expect { console.process }.to raise_error(SystemExit)
    end

    it 'calls .bye when user picks "exit"' do
      allow(console).to receive(:gets).and_return('exit')
      expect { console.process }.to raise_error(SystemExit)
    end

    it 'outputs an error message when user types something else' do
      allow(console).to receive(:gets).and_return('smh', 'exit')
      expect { console.process }.to output(/\n!!!!your guess is not valid!!!!/).to_stdout
      expect { console.process }.to raise_error(SystemExit)
    end
  end

  context '.conclusion' do
    it 'offers to save your score if user won' do
      allow(console).to receive(:gets).and_return('no', 'exit')
      expect { console.conclusion('++++') }.to output(/if you want to save your score type 'yes'\notherwise type anything else/).to_stdout
      expect { console.main_menu }.to raise_error(SystemExit)
    end

    it 'calls .main_menu' do
      allow(console).to receive(:gets).and_return('no', 'exit')
      expect(console).to receive(:main_menu)
      # expect(console).to receive(:bye)
      console.conclusion('++++')
    end
  end
end