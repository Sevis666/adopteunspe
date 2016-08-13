class Answer < ActiveRecord::Base
    @@students = %i(abecassis athor azizian beaulieu boutin bruneaux brunod
bustillo careil chardon cortes diridollou dumond fievet flechelles
gaborit georges godefroy haas khalfallah lanfranchi lecat ledaguenel laigret
lengele lequen lerbet lezanne lozach medmoun nguyen preumont qrichi rabineau ravetta rael
ren robina robind sahli scotti sourice steiner thomas vanel vital zhou)

    def scores
      s = {}
      @@students.each {|i| s[i] = read_attribute(i)}
      s.select! {|k, v| v>0}
      s = s.sort_by {|k, v| v}
      s.reverse
    end

    def print_scores
      scores.map do |k, v|
        "#{k.to_s.ljust(10)} : #{v.to_s.rjust(2)}".gsub(/lezanne/, "lezane")
      end
    end
end
