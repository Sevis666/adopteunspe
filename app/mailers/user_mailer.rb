class UserMailer < ActionMailer::Base
  default from: "Adopte Un Spé <server@adopteunepse.herokuapp.com>"

  def welcome(s)
    @spe = s
    mail(to: s.email, subject: s.full_name + " - Bienvenue sur notre site")
  end
end
