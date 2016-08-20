# coding: utf-8
class PagesController < ApplicationController
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
    if request.post?
      already_present = false
      if params[:question_id]
        already_present = true
        q = Question.find(params[:question_id])
      else
        q = Question.new
        q.vote = Vote.new
        q.suggested_coeff = SuggestedCoeff.new
      end
      q.question = params[:question]
      c = q.chosen_coeff(@spe)
      unless c == params["coeff"].to_i
        q.set_coeff(@spe, params["coeff"].to_i)
      end
      q.save

      params["answers"].each do |key, value|
        a = Answer.find_by(question_id: params[:question_id], answer_number: key.to_i)
        unless a
          a = Answer.new(answer: value["answer"], answer_number: key.to_i)
          q.answer << a
        end
        a.answer = value["answer"]
        a[@spe.username.to_sym] = value["points"].to_i
        a.save
      end

      if params.has_key? :unanswered
        redirect_to "/questions/unanswered"
      elsif params.has_key? :unrated
        redirect_to "/questions/unrated"
      else
        redirect_to "/questions#question-#{q.id}"
      end
    end
  end

  def modify_question
    params[:page] = "/questions/" + params[:id]
    check_cookie
  end

  def comment_question
    check_cookie
    q = Question.find(params[:id])
    c = Comment.new(user_id: @spe.id, comment: params[:comment])
    q.comment << c
    render nothing: true, status: 200
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
    user = User.find_by(token: params[:token])
    if request.post?
      params[:answers].each do |question_id, chosen_answer|
        UsersAnswer.new(user_id: user.id, question_id: question_id.to_i, answer_number: chosen_answer.to_i).save
      end
      redirect_to action: "user_login"
    end
  end

  private
  def check_authenticity(key)
    @spe = Spe.find_by(key: key)
    not @spe.nil?
  end

  def check_cookie
    cookie = cookies.permanent[:AdopteUnSpe_login]
    unless check_authenticity(cookie)
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
