require 'spec_helper'

RSpec.describe Game do
  let(:codebreaker) { Game.new(15, 2) }

  context '.comparing' do
    it 'is giving correct result' do
      codebreaker.instance_variable_set(:@secret_number, [1, 2, 3, 4])
      expect(codebreaker.comparing([1, 2, 3, 4])).to eq('++++')
      expect(codebreaker.comparing([1, 5, 2, 4])).to eq('++-')
      expect(codebreaker.comparing([3, 1, 2, 4])).to eq('+---')
      codebreaker.instance_variable_set(:@secret_number, [6, 6, 6, 6])
      expect(codebreaker.comparing([1, 6, 6, 1])).to eq('++')
      codebreaker.instance_variable_set(:@secret_number, [6, 5, 4, 3])
      expect(codebreaker.comparing([2, 2, 2, 2])).to eq('')
      expect(codebreaker.comparing([2, 6, 6, 6])).to eq('-')
      expect(codebreaker.comparing([6, 6, 6, 6])).to eq('+')
      expect(codebreaker.comparing([6, 5, 4, 4])).to eq('+++')
      expect(codebreaker.comparing([5, 6, 4, 3])).to eq('++--')
    end
  end

  context '.lost?' do
    it 'returns true when attempts_number is zero' do
      codebreaker.instance_variable_set(:@attempts_number, 0)
      expect(codebreaker.lost?).to eq(true)
    end

    it 'returns true when attempts_number is not zero' do
      codebreaker.instance_variable_set(:@attempts_number, 1)
      expect(codebreaker.lost?).to eq(false)
    end
  end

  context '.process' do
    let(:input_number) { [1, 2, 3, 4] }

    it 'decreases attempts_number' do
      codebreaker.instance_variable_set(:@attempts_number, 2)
      codebreaker.process(input_number)
      expect(codebreaker.attempts_number).to eq(1)
    end

    it 'increases attempts_used' do
      codebreaker.instance_variable_get(:@stats).send(:[], :attempts_used => 0)
      codebreaker.process(input_number)
      expect(codebreaker.stats[:attempts_used]).to eq(1)
    end

    it 'calls comparing' do
      expect(codebreaker).to receive(:comparing).with(input_number)
      codebreaker.process(input_number)
    end
  end

  context '.hint' do
    before(:each) do
      codebreaker.instance_variable_set(:@hints_number, 1)
      codebreaker.instance_variable_get(:@stats).send(:[], :hints_used => 0)
    end

    it 'returns nil if no hints left' do
      codebreaker.instance_variable_set(:@hints_number, 0)
      expect(codebreaker.hint).to eq(nil)
    end

    it 'returns a sample if there are hint left' do
      expect(codebreaker.hint.class).to eq(Integer)
    end

    it 'decreases hints number' do
      codebreaker.hint
      expect(codebreaker.hints_number).to eq(0)
    end

    it 'increases hints_used' do
      codebreaker.hint
      expect(codebreaker.stats[:hints_used]).to eq(1)
    end
  end
end
