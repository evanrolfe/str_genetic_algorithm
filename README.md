# Genetic Algorithm
A simple genetic algorithm to evolve a population of strings using the edit distance from the target string as the fitness function.
### Usage
```ruby
require 'genetic_algorithm'
ga = GeneticAlgorithm.new(target: 'EVAN', num_pop: 100, num_gen: 50)
ga.find_solution(verbose: true)
```
Example output:
```
0. Best: $Vgq (0.25) avg. fitness: 0.005
1. Best: $VA2 (0.5) avg. fitness: 0.01
2. Best: 9VA2 (0.5) avg. fitness: 0.0175
3. Best: 9VA2 (0.5) avg. fitness: 0.0325
4. Best: OVA2 (0.5) avg. fitness: 0.0625
5. Best: OVAa (0.5) avg. fitness: 0.1225
6. Best: OVA2 (0.5) avg. fitness: 0.2375
7. Best: OVAb (0.5) avg. fitness: 0.42
8. Best: OVA2 (0.5) avg. fitness: 0.4875
9. Best: OVA2 (0.5) avg. fitness: 0.47
10. Best: OVA2 (0.5) avg. fitness: 0.4825
11. Best: OVA2 (0.5) avg. fitness: 0.4775
12. Best:  VA2 (0.5) avg. fitness: 0.4775
13. Best: uVAN (0.75) avg. fitness: 0.4825
14. Best: (VAN (0.75) avg. fitness: 0.485
15. Best: (VAN (0.75) avg. fitness: 0.49
16. Best: (VAN (0.75) avg. fitness: 0.4825
17. Best: EVAN (1.0) avg. fitness: 0.5275
EVAN (1.0)
```
