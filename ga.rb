

##Test: Population's methods
#strings = ["exxx", "xvxx","xxax","xxxn","evxx"]
#individuals = strings.map{|str| Individual.new({:target => 'evan', :genotype => str}) }
#p = Population.new({:target => 'evan', :individuals => individuals})
#puts "Sum: #{p.sum_fitness}"								#Sum of fitness of this population is 0.25*4+0.5=1.5
#puts "Avg: #{p.avg_fitness}"								#average fitness of this population is sum/# = 1.5/5 = 0.3
#p.sort_by_fitness
#puts "Fittest individual: #{p.individuals[0]}"		#Fittest should be: "evxx"

##TEST: check that halve_pop returns an even number of elements
#ga = GeneticAlgorithm.new({:target => "evan", :seed => 10, :num_pop => 12})
#puts ga.half_pop(ga.population[]).length #should be 6
#ga = GeneticAlgorithm.new({:target => "evan", :seed => 10, :num_pop => 13})
#puts ga.half_pop(ga.population[]).length #should be 6
#ga = GeneticAlgorithm.new({:target => "evan", :seed => 10, :num_pop => 14})
#puts ga.half_pop(ga.population[]).length #should be 8

class Individual
	attr_reader :genotype

	def initialize(args = {})
		raise StandardError, "A target string must be declared for a Population!" unless args[:target]	#target is the only parameter that must be declared
		@target = args[:target]
		@genotype = args[:genotype]
		@mutation_p = args[:mutation_p] || 0.05
		@random = args[:random]
	end

	def to_s
		return "#{@genotype} (#{self.fitness})"
	end

	#Fitness value of 1.0 => perfect solution in range of [0.0,1.0]
	#Calculate by taking (# correct chars)/(# total chars)
	def fitness
		correct_chars = 0;
		@target.length.times{|i| correct_chars += 1 if @target[i] == @genotype[i] }
		return correct_chars.to_f
	end

	#Crossover function - recombines two organisms
	def +(spouse)
		#String genotype of child will be first half of mother + second half of father
		child_genotype = @genotype.length.times.map{|i| (i >= @genotype.length/2) ? @genotype[i] : spouse.genotype[i] }.join('')
		child = Individual.new({:target => @target, :crossover_p => @crossover_p, :mutation_p => @mutation_p, :genotype => child_genotype})
		child.mutate
		return child
	end

	def mutate
		@genotype = @genotype.split('').map{|char| (rand > @mutation_p) ? char : (rand(95)+32).chr }.join('')
	end
end

class Population
	attr_accessor :individuals

	def initialize(args = {})
		@random = (args[:seed]) ? Random.new(args[:seed]) : Random.new
		@target = args[:target]								#Target string
		@num_pop = args[:num_pop] || 500						#Number of members to be held in each generation
		@individuals = args[:individuals] || random_pop		#@individuals holds all the possible solutions for a single generation
	end

	def sort_by_fitness
		@individuals.sort!{|a,b| b.fitness <=> a.fitness }
	end

	def avg_fitness
		self.sum_fitness.to_f/@individuals.length.to_f
	end

	def sum_fitness
		@individuals.inject(0.0){|sum,n| sum += n.fitness}
	end

	#Create a population of random strings
	def random_pop
		@num_pop.to_i.times.map{ Individual.new({:target => @target, :genotype => self.random_string}) }
	end

	def []
		@individuals
	end

	def best_half
		self.sort_by_fitness
		@individuals[0..((@individuals.length/2).floor-1)]
	end

	def to_s
		self.sort_by_fitness
		"Best: #{@individuals[0]} avg. fitness: "+self.avg_fitness.to_s
	end

protected
	def random_string
		@target.length.times.map{ (@random.rand(95)+32).chr }.join('')
	end
end

class GeneticAlgorithm
	attr_reader :population

	def initialize(args={})
		@args = args
		@population = Population.new(args)
	end

	def find_solution
		solution_found = false
		num_gen = @args[:num_gen] || 100
		num_gen.times do |i|							
			puts i.to_s+". "+@population.to_s
			self.evolve_one_gen
		end

		#Return the solution
		return @population[][0]
	end

	def evolve_one_gen
		new_indvs = []

		#Select the fittest half of the population
		half = @population.best_half
		i = 0

		until new_indvs.length >= @population[].length do
			#Crossover each member in the array with the one after and the on after that
			new_indvs << half[(i+1) % half.length]+half[i % half.length]
			new_indvs << half[(i+2) % half.length]+half[i % half.length]
			i += 1
		end

		@population.individuals = new_indvs
	end
end

##Test: check Individual crossover function
#a = Individual.new({:target => 'evan'})
#b = Individual.new({:target => 'evan'})
#puts a
#puts b
#puts a+b

##Test: check Individual mutate function
#a = Individual.new({:target => 'evan', :mutation_p => 0.1})
#puts "Original Individual: "+a.to_s
#10.times do
#	a.mutate
#	puts a
#end

##Test: check Individual fitness function
#a = Individual.new({:target => 'evan', :genotype => 'evxx'})
#b = Individual.new({:target => 'evan', :genotype => 'evax'})
#c = Individual.new({:target => 'evan', :genotype => 'evan'})
#puts a
#puts b
#puts c


#TODO: move random generator to the Individual class
#TODO: it doesn't matter if there is an odd number of elements in the best half, but it matters that the new pop is the right size
ga = GeneticAlgorithm.new({:target => "evan rolfe", :num_pop => 500, :num_gen => 20})

puts ga.find_solution
