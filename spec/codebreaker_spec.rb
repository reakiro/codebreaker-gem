require 'spec_helper'

RSpec.describe Game do
  codebraker = Game.new

  it 'giving correct result' do
    expect(codebraker.comparing([1, 2, 3, 4], [1, 2, 3, 4])).to eq('++++')
    expect(codebraker.comparing([1, 2, 3, 4], [1, 5, 2, 4])).to eq('++-')
    expect(codebraker.comparing([1, 2, 3, 4], [3, 1, 2, 4])).to eq('+---')
    expect(codebraker.comparing([6, 6, 6, 6], [1, 6, 6, 1])).to eq('++')
    expect(codebraker.comparing([6, 5, 4, 3], [2, 2, 2, 2])).to eq('')
    expect(codebraker.comparing([6, 5, 4, 3], [2, 6, 6, 6])).to eq('-')
    expect(codebraker.comparing([6, 5, 4, 3], [6, 6, 6, 6])).to eq('+')
    expect(codebraker.comparing([6, 5, 4, 3], [6, 5, 4, 4])).to eq('+++')
    expect(codebraker.comparing([6, 5, 4, 3], [5, 6, 4, 3])).to eq('++--')
  end

  
end
