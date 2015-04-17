require "spec_helper"

RSpec.describe BayPhoto do
  it { should be_a(Module) }

  %i[Configuration].each do |mod|
    it "autoloads #{mod}" do
      expect(subject.autoload? mod).not_to be_nil
    end
  end
end

