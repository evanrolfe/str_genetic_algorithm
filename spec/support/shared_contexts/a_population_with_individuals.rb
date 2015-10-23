shared_context 'a_population_with_individuals' do
  let(:target) { 'EVAN' }
  let(:mutation_p) { 0.1 }
  let(:individual1) do
    GeneticAlgorithm::Individual.new(
      target: target,
      genotype: 'EVA_',
      mutation_p: mutation_p,
      random: nil
    )
  end
  let(:individual2) do
    GeneticAlgorithm::Individual.new(
      target: target,
      genotype: 'EV__',
      mutation_p: mutation_p,
      random: nil
    )
  end
  let(:individual3) do
    GeneticAlgorithm::Individual.new(
      target: target,
      genotype: 'E___',
      mutation_p: mutation_p,
      random: nil
    )
  end
  let(:individual4) do
    GeneticAlgorithm::Individual.new(
      target: target,
      genotype: '____',
      mutation_p: mutation_p,
      random: nil
    )
  end
  let(:individuals) { [individual1, individual2, individual3, individual4] }
  let(:num_pop) { 4 }
  let(:population) do
    GeneticAlgorithm::Population.new(target: 'EVAN', individuals: individuals, num_pop: num_pop)
  end
end
