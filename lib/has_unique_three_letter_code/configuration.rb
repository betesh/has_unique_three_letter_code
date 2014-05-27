module HasUniqueThreeLetterCode
  DEFAULT_FORBIDDEN_CODES = ['AID', 'AIL', 'ALL', 'ANA', 'AND', 'APP', 'ASA', 'ASK', 'ASS', 'BAD', 'BED', 'BOA', 'BOB', 'BOY', 'BRA', 'BRO', 'BUG', 'BUM', 'BUN', 'BUY', 'CRA', 'CRP', 'CUM', 'CUN', 'DID', 'DIE', 'DIK', 'DOA', 'DOG', 'EEL', 'FAG', 'FAT', 'FEE', 'FLU', 'FOO', 'FUC', 'FUK', 'FUN', 'GAG', 'GAY', 'GET', 'GOD', 'GOO', 'GOT', 'GOY', 'GUN', 'GUY', 'HAD', 'HAM', 'HEY', 'HIT', 'HOE', 'HOG', 'HOT', 'ICK', 'ILL', 'JEW', 'JIZ', 'LAW', 'LOO', 'MAX', 'MEX', 'MIN', 'MOB', 'MOM', 'MOO', 'NAG', 'NEG', 'NIG', 'NIP', 'ODD', 'OXY', 'PAY', 'PEE', 'PIE', 'PIG', 'POT', 'PUB', 'PUG', 'PUS', 'PUS', 'RAG', 'RED', 'REP', 'RET', 'RIM', 'SAD', 'SAG', 'SEX', 'SHI', 'SHT', 'SOB', 'SOL', 'SUB', 'SUE', 'SUK', 'TAX', 'TOI', 'TOY', 'URN', 'USA', 'WAD', 'WAP', 'WAY', 'WET', 'WIN', 'WOE', 'WOP', 'WOW', 'YEH', 'ZIT', 'ZOO']

  class << self
    def config
      @config ||= Configuration.new
    end
    def configure
      yield config
    end
  end

  class Configuration
    THREE_LETTERS = /[A-Z]{3}/

    attr_reader :forbidden_codes

    def initialize
      reset
    end

    def reset
      self.forbidden_codes = DEFAULT_FORBIDDEN_CODES.dup
    end

    def forbidden_codes=(_)
      raise ::ArgumentError, "config.forbidden_codes must be an array of 3-character strings.  For example: `config.forbidden_codes = ['ABC', 'DEF', 'GHI']`" unless _.is_a?(Array)

      _.reject { |code| 3 == code.size }.tap do |wrong_size|
        if 1 == wrong_size.size
          raise ::ArgumentError, "config.forbidden_codes contains an element that is the wrong length: #{wrong_size.first}"
        elsif 1 < wrong_size.size
          raise ::ArgumentError, "config.forbidden_codes contains elements that are the wrong length: #{wrong_size.join(', ')}"
        end
      end

      _.reject { |code| THREE_LETTERS.match(code) }.tap do |non_alpha|
        if 1 == non_alpha.size
          raise ::ArgumentError, "config.forbidden_codes contains an element with characters other than capital letters: #{non_alpha.first}"
        elsif 1 < non_alpha.size
          raise ::ArgumentError, "config.forbidden_codes contains elements with characters other than capital letters: #{non_alpha.join(', ')}"
        end
      end

      @forbidden_codes = _
    end
  end
end
