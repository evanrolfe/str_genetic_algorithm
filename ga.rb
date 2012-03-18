#Test: check chromosome crossover function
#a = Chromosome.new({:target => 'evan'})
#b = Chromosome.new({:target => 'evan'})
#puts a
#puts b
#puts a+b

#Test: check chromosome mutate function
#a = Chromosome.new({:target => 'evan', :mutation_p => 0.1})
#puts "Original Chromosome: "+a.to_s
#10.times do
#	a.mutate
#	puts a
#end

#Test: check chromosome fitness function
#a = Chromosome.new({:target => 'evan', :value => 'evxx'})
#b = Chromosome.new({:target => 'evan', :value => 'evax'})
#c = Chromosome.new({:target => 'evan', :value => 'evan'})
#puts a
#puts b
#puts c

##Test: Population's methods
#strings = ["exxx", "xvxx","xxax","xxxn","evxx"]
#individuals = strings.map{|str| Individual.new({:target => 'evan', :value => str}) }
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
	attr_reader :value

	def initialize(args = {})
		raise StandardError, "A target string must be declared for a Population!" unless args[:target]	#target is the only parameter that must be declared
		@target = args[:target]
		@value = args[:value] || random_string
		@crossover_p = args[:crossover_p] || 0.7
		@mutation_p = args[:mutation_p] || 0.05
		@random = args[:random]
	end

	def to_s; "#{@value} (#{self.fitness})" end

	#Fitness value of 1.0 => perfect solution in range of [0.0,1.0]
	#Calculate by taking (# correct chars)/(# total chars)
	def fitness
		correct_chars = 0;
		@target.length.times{|i| correct_chars += 1 if @target[i] == @value[i] }
		return (correct_chars.to_f)/(@target.length.to_f)
	end

	#Crossover function - recombines two organisms
	def +(spouse)
			#String value of child will be first half of mother + second half of father
			child_value = @value.length.times.map{|i| (i >= @value.length/2) ? @value[i] : spouse.value[i] }.join('')
			child = Individual.new({:target => @target, :crossover_p => @crossover_p, :mutation_p => @mutation_p, :value => child_value})
			child.mutate
			return child
	end

	def mutate; @value = @value.split('').map{|char| (rand > @mutation_p) ? char : (rand(95)+32).chr }.join('') end
end

class Population
	attr_accessor :individuals

	def initialize(args = {})
		@random = (args[:seed]) ? Random.new(args[:seed]) : Random.new
		@target = args[:target]								#Target string
		@num_pop = args[:num_pop] || 500						#Number of members to be held in each generation
		@individuals = args[:individuals] || random_pop		#@individuals holds all the possible solutions for a single generation
	end

	def sort_by_fitness; @individuals.sort!{|a,b| b.fitness <=> a.fitness } end

	def avg_fitness; self.sum_fitness.to_f/@individuals.length.to_f end

	def sum_fitness; @individuals.inject(0.0){|sum,n| sum += n.fitness} end

	#Create a population of random strings
	def random_pop; @num_pop.to_i.times.map{ Individual.new({:target => @target, :value => self.random_string}) } end

	def []; @individuals end

	def has_solution?
		self.sort_by_fitness
		return (@individuals[0].fitness == 1.0) ? true : false
	end

	def to_s
		"avg. fitness: "+self.avg_fitness.to_s
	end
protected
	def random_string; @target.length.times.map{ (@random.rand(95)+32).chr }.join('') end
end

class GeneticAlgorithm
	attr_reader :population

	def initialize(args={})
		@args = args
		@population = Population.new(args)
	end

	def find_solution
		solution_found = false
		i = 1
		until solution_found do
			puts i.to_s+". "+@population.to_s
			self.evolve_one_gen
			solution_found = true if @population.has_solution?
			i+=1
		end

		return @population[][0]
	end

	def evolve_one_gen
		new_indvs = []
		half = self.best_half(@population[])
		i = 0

		until new_indvs.length >= @population[].length do
			new_indvs << half[(i+1) % half.length]+half[i % half.length]
			new_indvs << half[(i+2) % half.length]+half[i % half.length]
			i += 1
		end

		@population.individuals = new_indvs
	end

	def best_half(population)
		population.sort!{|a,b| b.fitness <=> a.fitness }
		population[0..((population.length/2).floor-1)]
	end
end


#TODO: move random generator to the Individual class
#TODO: it doesn't matter if there is an odd number of elements in the best half, but it matters that the new pop is the right size
ga = GeneticAlgorithm.new({:target => "evan", :num_pop => 1000})

puts ga.find_solution
