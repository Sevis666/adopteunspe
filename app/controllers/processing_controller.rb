class ProcessingController < ApplicationController
  protect_from_forgery except: [:reset_users, :reset_godfathers, :match_pairs]

  @@students = %w(abecassis athor azizian beaulieu boutin bruneaux brunod
bustillo careil chardon cortes diridollou dumond fievet flechelles
gaborit georges godefroy haas khalfallah lanfranchi lecat ledaguenel laigret
lengele lequen lerbet lezanne lozach medmoun nguyen preumont qrichi rabineau ravetta rael
ren robina robind sahli scotti sourice steiner thomas vanel vital zhou)

  def reset_users
    check_token and return
    User.destroy_all
    UsersAnswer.destroy_all
    render nothing: true, status: 200
  end

  def reset_godfathers
    check_token and return
    stmts = ["UPDATE users SET godfather_id = NULL",
             "UPDATE spes SET elligible = true"]
    stmts.each do |stmt|
      ActiveRecord::Base.connection.execute(stmt)
    end
    render nothing: true, status: 200
  end

  def match_pairs
    check_token and return
    render nothing: true, status: 200
    puts "Starting algorithm"

    build_scores_query
    build_table

    spes = []
    Spe.all.order(:username).each_with_index do |s, i|
      spes << SpeStudent.new(s.full_name, i, @table, s.id, s.elligible)
    end
    sups = []
    User.all.order(:id).each_with_index do |u, i|
      sups << SupStudent.new(u.first_name + " " + u.last_name, i, @table, u.id)
    end
    puts "\n\nDone loading"

    while s = sups.find {|sup| sup.single?} do
      puts "\nConsidering single sup #{s}"
      s.propose_to spes[s.best_partner]
    end
    puts "\n\nFound matching pairs"

    sups.each do |s|
      puts "#{s} <-> #{s.fiance}"
      u = User.find(s.user_id)
      u.godfather_id = s.fiance.spe_id
      u.save
    end

    puts "\n\nProcessing ended"
  end

  private
  def check_token
    s = Spe.find_by(admin_token: params[:token])
    render nothing: true, status: 403 unless s
    s.nil?
  end

  def build_scores_query
    sums = @@students.map {|s| "SUM(#{s}) AS #{s}"}.join(', ')
    coeffs = @@students.map {|s| "q.coeff * #{s} AS #{s}"}.join(', ')
    @@scores_query = "SELECT #{sums} FROM " +
                     "(SELECT #{coeffs} " +
                     "FROM users_answers u INNER JOIN answers a ON a.question_id = u.question_id AND u.answer_number = a.answer_number INNER JOIN questions q ON q.id = u.question_id " +
                     "WHERE user_id = ?) t"
  end

  def retrieve_scores(user)
    ActiveRecord::Base.connection.execute(@@scores_query.sub("?", user.id.to_s)).first
  end

  def build_table
    @table = []
    User.all.order(:id).each_with_index do |u, i|
      @table[i] = retrieve_scores(u).sort_by {|k, v| k }.map {|a| a[1].to_i}
    end
  end

  class Student
    def initialize(name, id, affinity_table)
      @name = name
      @id = id
      @fiance = nil
      @affinity_table = affinity_table
    end
    attr_reader :name, :id
    attr_accessor :fiance

    def to_s
      @name
    end

    def free
      @fiance = nil
    end

    def single?
      @fiance.nil?
    end

    def engage(person)
      self.fiance = person
      person.fiance = self
    end
  end

  class SupStudent < Student
    def initialize(name, id, table, user_id)
      super(name, id, table)
      @proposals = []
      @user_id = user_id
    end
    attr_reader :user_id

    def best_partner
      best_score = nil
      best_id = nil
      @affinity_table[@id].each_with_index do |p, i|
        unless @proposals[i]
          if best_score.nil? || best_score < p
            best_score = p
            best_id = i
          end
        end
      end
      best_id
    end

    def affinity_with(person)
      @affinity_table[@id][person.id]
    end

    def propose_to(person)
      puts "#{self} proposes to #{person} (score #{affinity_with(person)})"
      @proposals[person.id] = true
      person.respond_to_proposal(self)
    end
  end

  class SpeStudent < Student
    def initialize(name, id, table, spe_id, elligible)
      super(name, id, table)
      @spe_id = spe_id
      @elligible = elligible
    end
    attr_reader :spe_id

    def affinity_with(person)
      @affinity_table[person.id][@id]
    end

    def better_choice?(person)
      affinity_with(person) > affinity_with(@fiance)
    end

    def respond_to_proposal(person)
      if single?
        puts engagement_message(person)
        engage(person)
      elsif better_choice?(person)
        puts dumping_message(person)
        @fiance.free
        engage(person)
      else
        puts refusal_message(person)
      end
    end

    def engagement_message(person)
      "#{self} accepts proposal from #{person}"
    end

    def dumping_message(person)
      "#{self} dumps #{@fiance} for #{person} (previous score #{affinity_with(@fiance)})"
    end

    def refusal_message(person)
      s = "#{self} refuses proposal from #{person} "
      s += "(already taken)" unless @ellgible
      s += "(previous score #{affinity_with(@fiance)})" unless @fiance.nil?
    end
  end
end
