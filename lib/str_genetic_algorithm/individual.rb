class StrGeneticAlgorithm
  class Individual
    attr_reader :genotype, :target, :mutation_p

    def initialize(args = {})
      raise StandardError, 'A target string must be declared for a Population!' unless args[:target]
      @target = args[:target]
      @genotype = args[:genotype] || Random.generate_string(@target.length)
      @mutation_p = args[:mutation_p] || 0.05
    end

    #Fitness value of 1.0 => perfect solution in range of [0.0,1.0]
    #Calculate by taking (# correct chars)/(# total chars)
    def fitness
      correct_chars = 0;
      target.length.times do |i|
        correct_chars += 1 if target[i] == genotype[i]
      end

      correct_chars.to_f / target.length.to_f
    end

    #Crossover function - recombines two individuals
    def +(other)
      father_genotype = genotype
      mother_genotype = other.genotype
      half_i = genotype.length / 2

      child_genotype =
        mother_genotype[0..half_i - 1] +
        father_genotype[half_i..genotype.length]

      child = Individual.new(
        target: target,
        mutation_p: mutation_p,
        genotype: child_genotype
      )

      child.mutate
      child
    end

    def mutate
      @genotype = genotype.split('').map do |char|
        Random.randomize_or_leave_char(char, mutation_p)
      end.join('')
    end

    def to_s
      "#{@genotype} (#{self.fitness})"
    end
  end
end
