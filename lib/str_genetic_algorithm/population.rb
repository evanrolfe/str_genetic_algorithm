class StrGeneticAlgorithm
  class Population
    attr_accessor :target, :num_pop, :individuals

    def initialize(args = {})
      @target = args[:target]
      @num_pop = args[:num_pop] || 50
      @individuals = args[:individuals] || generate_random_population
    end

    def evolve_one_gen
      new_individuals = []
      i = 0

      until new_individuals.length == individuals.length
        #Crossover each member in the array with the one after and the on after that
        new_individuals << best_half[(i + 1) % best_half.length] + best_half[i % best_half.length]
        new_individuals << best_half[(i + 2) % best_half.length] + best_half[i % best_half.length]
        i += 1
      end

      @individuals = new_individuals
    end

    def best_individual
      individuals_sorted_by_fitness[0]
    end

    private

    def avg_fitness
      sum_fitness.to_f / individuals.length.to_f
    end

    def sum_fitness
      individuals.map(&:fitness).reduce(:+)
    end

    def best_half
      half_i = (individuals.length / 2).floor - 1
      individuals_sorted_by_fitness[0..half_i]
    end

    def generate_random_population
      num_pop.to_i.times.map do
        Individual.new(target: target)
      end
    end

    def individuals_sorted_by_fitness
      @individuals.sort { |a, b| b.fitness <=> a.fitness }
    end

    def to_s
      "Best: #{best_individual} avg. fitness: #{avg_fitness}"
    end
  end
end
