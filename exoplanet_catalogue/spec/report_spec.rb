require 'spec_helper'
require 'report'

# Sorry no time to create test cases
describe Report::ExoplanetReport do
  describe '#create_report' do
    let(:report_obj) { Report::ExoplanetReport.new }

    # Test cases for creating report
    it 'creates report' do
      allow(report_obj).to receive(:create_report)
    end

    # Validation test cases
    it 'validates' do
    end
  end
end
