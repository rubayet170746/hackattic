module Hackattic
  class MiniMiner
    def initialize(block:, difficulty:)
      @block = block
      @difficulty = difficulty
    end

    def call
      solution, tries, time = self.mine
      puts "Solution found after #{time.round}s and #{tries} tryouts."
      { nonce: solution }
    end

    def mine
      tries = 0
      time_start = Time.now
      seed = Random.new.rand(2 ** @difficulty - 1)
      loop do
        solution = calculate_solution(seed)
        return [seed, tries, Time.now - time_start] if check(solution)
        tries = tries + 1
        seed = seed + 1
      end
    end

    def check(solution)
      # Digits to check.
      checking_digits = @difficulty.fdiv(4).ceil
      binary_number = solution[0..checking_digits - 1].split('').each_with_object('') do |digit, obj|
        # Converting each digit individually to binary in descending order,
        # ensuring extra zeros if needed.
        obj << digit.hex.to_s(2).rjust(4, '0')
      end
      puts "#{binary_number.gsub('0', '0'.yellow.bold)} (D: #{@difficulty}, S: #{solution})"
      binary_number.start_with?('0' * @difficulty)
    end

    def calculate_solution(seed)
      block = @block.merge(nonce: seed).sort_by { |k, _| k }.to_h
      body = Oj.dump(block, mode: :compat)
      Digest::SHA256.hexdigest(body)
    end
  end
end
