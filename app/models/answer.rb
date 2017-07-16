class Answer < ActiveRecord::Base
  has_many :answer_points

    def scores
      s = {}
      $username_cache ||= Spe::build_username_cache
      answer_points.each do |ap|
        s[$username_cache[ap.spe_id]] = ap.score
      end
      s.select! {|k, v| v>0}
      s = s.sort_by {|k, v| v}
      s.reverse
    end

    def print_scores
      scores.map do |k, v|
        "#{k.to_s.ljust(10)} : #{v.to_s.rjust(2)}"
      end
    end

    def set_points(points, spe)
      ap = answer_points.find_by(spe_id: spe.id) ||
        AnswerPoint.new(answer_id: id, spe_id: spe.id)
      ap.score = points
      ap.save
    end

    def points(spe)
      ap = answer_points.find_by(spe_id: spe.id)
      ap.nil? ? 0 : ap.score
    end

    def shred
      answer_points.destroy_all
      destroy
    end

    def self.build_scores_table
      $username_cache ||= Spe::build_username_cache
      table = Hash.new { |h,k| h[k] = {} }
      AnswerPoint.find_each do |ap|
        table[ap.answer_id][ap.spe_id] = ap.score
      end
      table.keys.each do |id|
        table[id] = table[id].sort_by { |k, v| v }.reverse
          .map { |spe_id, score|
            score == 0 ? "" : $username_cache[spe_id].to_s + ": " + score.to_s + ','
          }.join.chop
      end
      table
    end
end
