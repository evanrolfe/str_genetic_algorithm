class GeneticAlgorithm
  module Random
    def self.randomize_or_leave_char(char, probability)
      if rand < probability
        self.random_char
      else
        char
      end
    end

    def self.generate_string(length)
      length.times.map { self.random_char }.join('')
    end

    def self.random_char
      (rand(95)+32).chr
    end
  end
end
