require_relative 'genetic_algorithm/random'
require_relative 'genetic_algorithm/individual'
require_relative 'genetic_algorithm/population'

class GeneticAlgorithm
  attr_reader :population, :num_gen

  def initialize(args={})
    @num_gen = args[:num_gen] || 50
    @population = Population.new(args)
  end

  def find_solution(verbose: false)
    i = 0
    print(i) if verbose
    until population.best_individual.fitness == 1.0 || i == num_gen
      population.evolve_one_gen
      i += 1
      print(i) if verbose
    end

    population.best_individual
  end

  private

  def print(i)
    puts "#{i}. #{population}"
  end
end
