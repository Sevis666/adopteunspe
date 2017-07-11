class Answer < ActiveRecord::Base
  has_many :answer_points

    def scores
      s = {}
      answer_points.each do |ap|
        s[Spe.find(ap.spe_id).username.to_sym] = ap.score
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
end
