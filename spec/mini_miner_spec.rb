RSpec.describe Hackattic::MiniMiner do
  context 'finds solution' do
    let(:block) { { data: [], nonce: nil} }
    let(:instance) do
      described_class.new(block: block, difficulty: 8)
    end

    let(:solution) { instance.calculate_solution(45) }

    it { expect(instance.check(solution)).to be_truthy }
  end
end
