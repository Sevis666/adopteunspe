class Config
  @@freeze_vars = { questions: "questions_freezed",
                    answers: "answers_freezed",
                    answer_points: "answer_points_freezed" }

  def self.frozen?(sym)
    c = self.freeze_var(sym)
    c.save
    c.value == "1"
  end

  def self.freeze(sym)
    c = self.freeze_var(sym)
    c.value = "1"
    c.save
    c
  end

  def self.freeze_var(sym)
    raise ArgumentError unless @@freeze_vars.has_key? sym
    ConfigVar.find_by(name: @@freeze_vars[sym]) ||
      ConfigVar.new(name: @@freeze_vars[sym], value: "0")
  end
end
