# coding: utf-8
class PagesController < ApplicationController
  protect_from_forgery except: [:users_list]

  def root
    if Config::frozen? :answer_points
      redirect_to "/user_login"
    else
      redirect_to "/index"
    end
  end

  def index
  end

  def message_board
    check_cookie
  end

  def questions
    params[:page] = "/questions"
    check_cookie
  end

  def questions_unvoted
    params[:page] = "/questions/unvoted"
    check_cookie
  end

  def questions_unanswered
    params[:page] = "/questions/unanswered"
    @unanswered = true
    check_cookie
  end

  def questions_unrated
    params[:page] = "/questions/unrated"
    @unrated = true
    check_cookie
  end

  def add_new_question
    params[:page] = "/questions/new"
    check_cookie
    return unless request.post?
    q = nil
    q = Question.find(params[:question_id]) if params.has_key? :question_id
    already_present = !q.nil?
    redirect_to_questions_list and return if Config::frozen?(:questions) && q.nil?
    q ||= Question.new

    unless Config::frozen?(:questions) || q.question == params[:question]
      Log::log_question_change(q, @spe, params[:question]) if already_present
      q.question = params[:question]
    end

    chain = []
    if params.has_key? :unanswered
      chain = @spe.unanswered_questions.map(&:id)
    elsif params.has_key? :unrated
      chain = @spe.unrated_questions.map(&:id)
    end

    c = q.chosen_coeff(@spe)
    unless c == params["coeff"].to_i
      q.set_coeff(@spe, params["coeff"].to_i)
    end
    q.save

    Log::log_new_question(q, @spe) unless already_present

    unless params["answers"].nil?
      sum = params["answers"].map {|k, v| v["points"].to_i}.sum.to_f
      params["answers"].each do |key, value|
        a = Answer.find_by(question_id: params[:question_id], answer_number: key.to_i)
        answer_already_present = !a.nil?
        unless a
          next if Config::frozen?(:answers) || !value.has_key?(:answer) || value["answer"].size == 0
          a = Answer.new(answer: value["answer"], answer_number: key.to_i)
          q.answer << a
        end
        unless Config::frozen?(:answers) || a.answer == value["answer"]
          Log::log_answer_change(a, @spe, value["answer"]) if answer_already_present
          a.answer = value["answer"]
        end
        point = value["points"].to_i
        a.set_points(point, @spe) unless Config::frozen?(:answer_points)
        a.save
        Log::log_new_answer(a, @spe) unless answer_already_present
      end
    end
    redirect_to_questions_list(q, chain)
  end

  def redirect_to_questions_list(q = nil, chain = [])
    if params.has_key? :unanswered
      if params.has_key?(:chain) && !q.nil?
        id = chain.index(q.id)
        if !id.nil? && id + 1 < chain.size
          redirect_to "/questions/#{chain[id + 1]}?unanswered&chain" and return
        end
      end
      redirect_to "/questions/unanswered"
    elsif params.has_key? :unrated
      if params.has_key?(:chain) && !q.nil?
        id = chain.index(q.id)
        if !id.nil? && id < chain.size
          redirect_to "/questions/#{chain[id + 1]}?unrated&chain" and return
        end
      end
      redirect_to "/questions/unrated"
    elsif q
      redirect_to "/questions#question-#{q.id}"
    else
      redirect_to "/questions"
    end
    true
  end

  def modify_question
    params[:page] = "/questions/" + params[:id]
    check_cookie
  end

  def comment_question
    check_cookie
    q = Question.find(params[:id])
    if params.has_key?(:comment) && params[:comment].size > 0
      c = Comment.new(user_id: @spe.id, comment: params[:comment])
      q.comment << c
      Log::log_comment(q, @spe, c)
    end
    render nothing: true, status: 200
  end

  def godson_answers
    params[:page] = "/godson_answers"
    check_cookie
  end

  def serve_public_key
    render file: 'public/sevisKey.asc', layout: false
  end

  def login
    if request.post?
      if check_authenticity(params[:key])
        set_cookie(params[:key])
        redirect_to_page
      else
        @error = "Votre clé est invalide, merci de contacter les développeurs"
      end
    end
  end

  def vote_question
    check_cookie
    q = Question.find(params[:id])
    if params[:upvote] == ""
      q.upvote(@spe)
    elsif params[:downvote] == ""
      q.downvote(@spe)
    end
    render nothing: true, status: 200
  end

  def user_login
  end

  def register_user
    u = User.new(first_name: params[:first_name], last_name: params[:last_name],
                 email: params[:email],
                 phonenumber: params[:phonenumber],
                 gender: params[:gender],
                 birthday: Date.parse("#{params["year-of-birth"]}-#{params["month-of-birth"]}-#{params["day-of-birth"]}"))
    u.save
    token = u.calculate_token
    redirect_to action: "survey", token: token
  end

  def survey
    if request.post?
      user = User.find_by(token: params[:token])
      redirect_to action: "user_login" if user.nil?
      params[:answers].each do |question_id, chosen_answers|
        chosen_answers.split(";").select {|s| s.size > 0 }.map(&:to_i).select {|s| s > 0 }.sort.uniq.each do |answer_number|
          UsersAnswer.new(user_id: user.id, question_id: question_id.to_i, answer_number: answer_number).save
        end
      end
      redirect_to action: "user_login"
    end
  end

  def users_list
  end

  private
  def check_authenticity(key)
    @spe = Spe.find_by(key: key)
    not @spe.nil?
  end

  def check_cookie
    cookie = cookies.permanent[:AdopteUnSpe_login]
    if check_authenticity(cookie)
      Log::spe_connection(@spe)
    else
      redirect_to "/login?page=#{params[:page]}"
    end
  end

  def set_cookie(key)
    cookies.permanent[:AdopteUnSpe_login] = key
  end

  def redirect_to_page
    params[:page] ||= "/"
    redirect_to params[:page]
  end
end
