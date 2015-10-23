require 'spec_helper'

describe StrGeneticAlgorithm::Individual do
  let(:target) { 'a_random_string' }
  let(:genotype) { 'skdlfnwreovuszo' }
  let(:mutation_p) { 0.1 }
  let(:individual) do
    described_class.new(
      target: target,
      genotype: genotype,
      mutation_p: mutation_p,
      random: nil
    )
  end

  describe '#initialize' do
    context 'target is defined' do
      subject { individual }

      its(:genotype) { is_expected.to eq(genotype) }
      its(:target) { is_expected.to eq(target) }
      its(:mutation_p) { is_expected.to eq(mutation_p) }
    end

    context 'target is defined but genotype is not' do
      let(:genotype) { nil }
      let(:random_string) { 'A_RANDOM_STRING' }

      before do
        allow(StrGeneticAlgorithm::Random).to receive(:generate_string).and_return(random_string)
      end

      subject! { individual }

      it { expect(StrGeneticAlgorithm::Random).to have_received(:generate_string).with(target.length) }
      its(:genotype) { is_expected.to eq(random_string) }
      its(:target) { is_expected.to eq(target) }
      its(:mutation_p) { is_expected.to eq(mutation_p) }
    end

    context 'target is not defined' do
      let(:target) { nil }

      subject { individual }

      it { expect { subject }.to raise_error }
    end
  end

  describe '#to_s' do
    let(:fitness_value) { 1.0 }

    before do
      allow(individual).to receive(:fitness).and_return(fitness_value)
    end

    subject { individual.to_s }

    it { is_expected.to eq("#{genotype} (#{fitness_value})") }
  end

  describe '#fitness' do
    context 'genotype matches target' do
      let(:target) { 'EVAN' }
      let(:genotype) { 'EVAN' }

      subject { individual.fitness }

      it { is_expected.to eq(1.0) }
    end

    context 'genotype off target by 1 char' do
      let(:target) { 'EVAN' }
      let(:genotype) { 'EVA_' }

      subject { individual.fitness }

      it { is_expected.to eq(0.75) }
    end
  end

  describe '#+' do
    let(:target) { 'EVOLVE' }
    let(:genotype1) { 'XXXXXX' }
    let(:individual1) do
      described_class.new(
        target: target,
        genotype: genotype1,
        mutation_p: 0.0,
        random: nil
      )
    end
    let(:genotype2) { 'YYYYYY' }
    let(:individual2) do
      described_class.new(
        target: target,
        genotype: genotype2,
        mutation_p: 0.0,
        random: nil
      )
    end

    subject { individual1 + individual2 }

    its(:genotype) { is_expected.to eq('YYYXXX') }
  end

  describe '#mutate' do
    let(:genotype) { 'BEFORE_MUTATION' }

    before do
      allow(StrGeneticAlgorithm::Random).to receive(:randomize_or_leave_char).and_return('A')
    end

    subject! { individual.mutate }

    it { expect(StrGeneticAlgorithm::Random).to have_received(:randomize_or_leave_char).exactly(15).times }
    it { expect(individual.genotype).to eq('AAAAAAAAAAAAAAA') }
  end
end
