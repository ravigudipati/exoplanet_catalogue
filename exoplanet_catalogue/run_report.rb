require_relative "lib/report"

class RunReport
  include Report

  def self.run
    exo_planet = Report::ExoplanetReport.new
    exo_planet.create_report
  end

end

# Run the program
RunReport.run
