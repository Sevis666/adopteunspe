require 'base64'

class Log < ActiveRecord::Base
  @@categories = [:question_creation, :question_change, :question_shred,
                  :answer_creation, :answer_change,
                  :comment]

  def reversible?
    reversible
  end

  def self.list(count = 50)
    count = Log.count if count == -1
    Log.order('created_at DESC').limit(count)
  end

  def self.spe_connection(spe)
    ConnectionLog::log_connection(spe) unless spe.nil?
  end

  def self.log_comment(question, spe, comment)
    Log.new(category: @@categories.index(:comment),
            reversible: true,
            description: "#{spe.full_name} commented on question ##{question.id} :" +
            " \"#{comment.comment}\"",
            blob: spe.id.to_s.rjust(4, '0') + comment.id.to_s.rjust(4, '0'))
      .save
  end

  def self.log_new_question(question, spe)
    Log.new(category: @@categories.index(:question_creation),
            reversible: true,
            description: "#{spe.full_name} created question ##{question.id} :" +
            " \"#{question.question}\"",
            blob: spe.id.to_s.rjust(4, '0') + question.id.to_s.rjust(4, '0'))
      .save
  end

  def self.log_question_change(question, spe, new_question)
    puts question.inspect
    Log.new(category: @@categories.index(:question_change),
            reversible: true,
            description: "#{spe.full_name} changed question ##{question.id}" +
            " from \"#{question.question}\" to \"#{new_question}\"",
            blob: spe.id.to_s.rjust(4, '0') + question.id.to_s.rjust(4, '0') +
            Base64.encode64(question.question || "") )
      .save
  end

  def self.log_new_answer(answer, spe)
    Log.new(category: @@categories.index(:answer_creation),
            reversible: true,
            description: "#{spe.full_name} created answer ##{answer.id}" +
            " for question #{answer.question_id} : \"#{answer.answer}\"",
            blob: spe.id.to_s.rjust(4, '0') + answer.id.to_s.rjust(4, '0'))
      .save
  end

  def self.log_answer_change(answer, spe, new_answer)
    Log.new(category: @@categories.index(:answer_change),
            reversible: true,
            description: "#{spe.full_name} changed answer ##{answer.id}" +
            " from \"#{answer.answer}\" to \"#{new_answer}\"",
            blob: spe.id.to_s.rjust(4, '0') + answer.id.to_s.rjust(4, '0') +
            Base64.encode64(answer.answer) )
      .save
  end

  def self.log_shred_question(question)
    Log.new(category: @@categories.index(:question_shred),
            reversible: false,
            description: "Server shredded question ##{question.id} :" +
            " \"#{question.question}\"")
      .save
  end
end
