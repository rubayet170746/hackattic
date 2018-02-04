require 'faraday'
require 'colorize'
require 'oj'
require 'digest'

Dir[File.expand_path('../hackattic/**/*.rb', __FILE__)].each { |f| require f }

module Hackattic
  using Refinements::Inflector

  def self.solve(challenge)
    challenge_normalized = challenge.to_s.underscore
    input = get(challenge_normalized)
    handler = Object.const_get("Hackattic::#{challenge_normalized.camelize}").new(input)
    solution = handler.call
    send_solution(challenge_normalized, solution)
  end

  def self.get(challenge)
    response = Faraday.get(url(challenge, 'problem'))
    Oj.load(response.body, symbol_keys: true)
  end

  def self.send_solution(challenge, solution)
    payload = Oj.dump(solution, mode: :compat)
    response = Faraday.post(url(challenge, 'solve'), payload, 'Content-Type' => 'application/json')
    puts response.body
  end

  private

  def self.url(challenge, mode)
    token_param = URI.encode_www_form(access_token: ENV['ACCESS_TOKEN'])
    path = "#{challenge}/#{mode}?#{token_param}"
    URI.join(ENV['HACKATTIC_URL'], path).to_s
  end
end
