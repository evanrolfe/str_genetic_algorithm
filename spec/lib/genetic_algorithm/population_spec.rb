require 'spec_helper'

describe GeneticAlgorithm::Population do
  include_context 'a_population_with_individuals'

  describe '#individuals_sorted_by_fitness' do
    let(:individuals) { [individual4, individual3, individual2, individual1] } # Increasing order of fitness

    subject { population.send(:individuals_sorted_by_fitness) }

    it { is_expected.to eq([individual1, individual2, individual3, individual4]) } # Decreasing order of fitness
  end

  describe '#avg_fitness' do
    subject { population.send(:avg_fitness) }

    it { is_expected.to eq(0.375) }
  end

  describe '#sum_fitness' do
    subject { population.send(:sum_fitness) }

    it { is_expected.to eq(1.5) }
  end

  # TODO: Mock calls made to GeneticAlgorithm::Random
  describe '#generate_random_population' do
    let(:individual) { double(GeneticAlgorithm::Individual) }

    before do
      allow(GeneticAlgorithm::Individual).to receive(:new).and_return(individual)
    end

    subject! { population.send(:generate_random_population) }

    it do
      expect(GeneticAlgorithm::Individual).to have_received(:new).at_least(num_pop).times
        .with(target: target)
    end
  end

  describe '#best_half' do
    let(:individuals) { [individual4, individual3, individual2, individual1] } # Increasing order of fitness

    subject! { population.send(:best_half) }

    it { is_expected.to eq([individual1, individual2]) }

    it 'should leave the order of the individuals unchanged' do
      expect(population.individuals[0].fitness).to be < population.individuals[3].fitness
    end
  end
end
