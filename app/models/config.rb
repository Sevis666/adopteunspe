class Config
  @@freeze_vars = { questions: "questions_freezed",
                    answers: "answers_freezed",
                    answer_points: "answer_points_freezed" }

  def self.frozen?(sym)
    cache_key = "freeze-var_#{sym.to_s}"
    Rails.cache.fetch(cache_key, expires_in: 2.days) do
      c = self.freeze_var(sym)
      c.save
      c.value == "1"
    end
  end

  def self.freeze(sym)
    self.set_freeze_value(sym, 1)
  end

  def self.unfreeze(sym)
    self.set_freeze_value(sym, 0)
  end

  private
  def self.expire_cache(sym)
    Rails.cache.delete("freeze-var_#{sym.to_s}")
  end

  def self.set_freeze_value(sym, value)
    expire_cache(sym)
    c = self.freeze_var(sym)
    c.value = value.to_s
    c.save
    c
  end

  def self.freeze_var(sym)
    raise ArgumentError unless @@freeze_vars.has_key? sym
    ConfigVar.find_by(name: @@freeze_vars[sym]) ||
      ConfigVar.new(name: @@freeze_vars[sym], value: "0")
  end
end
