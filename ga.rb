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

class Chromosome
	attr_reader :value

	def initialize(args = {})
		raise StandardError, "A target string must be declared for a Population!" unless args[:target]	#target is the only parameter that must be declared
		@target = args[:target]
		@value = args[:value] || random_string
		@crossover_p = args[:crossover_p] || 0.7
		@mutation_p = args[:mutation_p] || 0.05
		@random = args[:random]
	end

	def to_s
		"#{@value} (#{self.fitness})"
	end

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
			return Chromosome.new({:target => @target, :crossover_p => @crossover_p, :mutation_p => @mutation_p, :value => child_value})
	end

	def mutate
		@value = @value.split('').map{|char| (rand > @mutation_p) ? char : (rand(95)+32).chr }.join('')
	end
end

class Population
	attr_accessor :chromosomes #Purely for testing purposes

	def initialize(args = {})

		#raise StandardError, "A target string must be declared for a Population!" unless args[:target]	#target is the only parameter that must be declared
		@target = args[:target]								#Target string
		@num_pop = args[:num_pop] || 500					#Number of members to be held in each generation
		@chromosomes = args[:chromosomes] || random_pop		#@chromosomes holds all the possible solutions for a single generation
		@elite_percent = 0.1								#Top x% will survive to the next generation no matter what

		@random = (args[:seed]) ? Random.new(args[:seed]) : Random.new
	end

#Modular/Functional methods
	def sort_by_fitness(chromosomes)
		chromosomes.sort!{|a,b| b.fitness <=> a.fitness }
	end

	def avg_fitness(chromosomes)
		self.sum_fitness(chromosomes).to_f/chromosomes.length.to_f
	end

	def sum_fitness(chromosomes)
		chromosomes.inject(0.0){|sum,n| sum += n.fitness}
	end

#Random Functions

	#Create a population of random strings
	def random_pop
		@num_pop.to_i.times.map{ Chromosome.new({:target => @target, :value => self.random_string}) }
	end

	def random_string
		@target.length.times.map{ (rand(95)+32).chr }.join('')
	end

	def test
		puts @random.rand
	end
end

#Test: Population's methods
strings = ["exxx", "xvxx","xxax","xxxn","evxx"]
chromosomes = strings.map{|str| Chromosome.new({:target => 'evan', :value => str}) }
p = Population.new({:target => 'evan', :chromosomes => chromosomes})
puts "Sum: #{p.sum_fitness(p.chromosomes)}"								#Sum of fitness of this population is 0.25*4+0.5=1.5
puts "Avg: #{p.avg_fitness(p.chromosomes)}"								#average fitness of this population is sum/# = 1.5/5 = 0.3
puts "Fittest chromosome: #{p.sort_by_fitness(p.chromosomes)[0]}"		#Fittest should be: "evxx"

#Test: Random generator
p2 = Population.new({:target => 'evan', :seed => 1})
p2.test
