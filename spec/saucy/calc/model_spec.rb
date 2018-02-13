require "spec_helper"

require "saucy/calc/model"

describe Saucy::Calc::Model do

  subject(:calc) { described_class.new }

  context "new" do
    it "starts at zero" do
      expect(calc.value).to eq(0.0)
    end
  end

  describe "#add" do

    it "adds" do
      calc.add(5)
      expect(calc.value).to eq(5.0)
    end

  end

  describe "#set" do

    it "sets the specified value" do
      calc.add(5)
      calc.set(3)
      expect(calc.value).to eq(3.0)
    end

  end

  describe "#clear" do

    it "clears the value" do
      calc.add(5)
      calc.clear
      expect(calc.value).to eq(0.0)
    end

  end

end