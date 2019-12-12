require 'json'

module Report
  class ExoplanetReport
    def initialize()
      @report_data = Hash.new{|h,k| h[k] = []}
    end

    def create_report
      count_orphan = 0
      planets = {}
      hot_stars = []

      data = JSON.parse(`curl https://gist.githubusercontent.com/joelbirchler/66cf8045fcbb6515557347c05d789b4a/raw/9a196385b44d4288431eef74896c0512bad3defe/exoplanets`)

      return "No data" if (data.nil? || data.length == 0)

      data.each do|planet|
        # count number of orphan planets
        count_orphan = count_orphan + 1 if planet['TypeFlag'] == 3

        # Planet orbiting the hottest star - check HostStarTempK
        unless planet['HostStarTempK'].to_i == 0
          planets[planet['HostStarTempK'].to_i] = planet['PlanetIdentifier']
          hot_stars << planet['HostStarTempK'].to_i
        end

        next if planet['RadiusJpt'].to_f == 0 || planet['DiscoveryYear'].to_i == 0

        unless planet['DiscoveryYear'].nil?
          # Timeline the number of planets discovered
          if planet['RadiusJpt'].to_f < 1.0
            @report_data[planet['DiscoveryYear']][0] = (@report_data[planet['DiscoveryYear']][0].nil? ? 0 : @report_data[planet['DiscoveryYear']][0]) + 1
          elsif planet['RadiusJpt'].to_f < 2.0
            @report_data[planet['DiscoveryYear']][1] = (@report_data[planet['DiscoveryYear']][1].nil? ? 0 : @report_data[planet['DiscoveryYear']][1]) + 1
          elsif planet['RadiusJpt'].to_f > 2.0
            @report_data[planet['DiscoveryYear']][2] = (@report_data[planet['DiscoveryYear']][2].nil? ? 0 : @report_data[planet['DiscoveryYear']][2]) + 1
          end
        end
      end

      @report_data['count_orphan'] = count_orphan
      @report_data['hot_star'] = planets[hot_stars.max]

      display_report
    end

private

    def display_report
      @report_data.each do|k,v|
        if k == 'count_orphan'
          puts "The number of orphan planets: #{@report_data['count_orphan']}"
        elsif k == 'hot_star'
          puts "The name of the hottest star: #{@report_data['hot_star']}"
        else
          v[0].nil? ? v[0] = 0 : v[0] 
          v[1].nil? ? v[1] = 0 : v[1] 
          v[2].nil? ? v[2] = 0 : v[2] 
          puts "Discovered in the year #{k}: #{v[0]} small planets, #{v[1]} medium planets and #{v[2]} large planets" 
        end
      end
    end
  end
end

