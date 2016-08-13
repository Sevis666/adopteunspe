# coding: utf-8
class PagesController < ApplicationController
  def index
  end

  def questions
    params[:page] = "/questions"
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
      end
      q.question = params[:question]
      q.save

      params["answers"].each do |key, value|
        unless value["points"].nil?
          points = {}
          value["points"].each do |k, v|
            points[ v["student"].to_sym] = v["value"].to_i unless (v["student"] == "")
          end
        end

        a = Answer.find_by(question_id: params[:question_id], answer_number: key.to_i)
        if a
          a.answer = value["answer"]
          points.each do |student, p|
            a[student] = p
          end unless points.nil?
          a.save
        else
          a = Answer.new(answer: value["answer"], answer_number: key.to_i, **points)
          q.answer << a
        end
      end

      redirect_to "/questions"
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
