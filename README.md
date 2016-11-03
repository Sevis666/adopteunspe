# Adopte Un Spé

Built for Louis-le-Grand's MPSI2, but should be reusable with a few hardcode changes.

## Install

Pull the code, make the following changes so it matches your classmates' names, and push to your production server. It is already Heroku-ready, more info on [Heroku Rails's starting page][https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction]

### Hardcode fixes

No worries, this will be fixed in a future release. In case you want to use this version, here are the files that you need change :

+ app/models/question.rb
+ app/models/answer.rb
+ app/views/pages/add_new_question.html.erb
+ app/controllers/processing_controller.rb
+ db/migrate/20160820124301_clean_users_answers.rb
+ db/migrate/20160803131749_create_structure.rb
+ db/migrate/20160815124353_add_scores.rb

In these files, replace the global students variable with your own list of ids. The order does not matter.

In db/seeds.rb, use your own information, but make sure that the ids match.

#### When will this be fixed ?

Hopefully by the end of April 2017, maybe before. These variables were hardcoded because I was in a hurry, if you want to be notified when an updated version is available or want to fix this yourself, please e-mail me and feel free to make a pull request.

## Description

This is a website to choose godfathers for the newcomers in MPSI2. 

It's built as a joke, and used during our first day of class, to welcome the new students. This is why it uses the famous [Adopte un mec][http://adopteunmec.com] theme. I _do not_ own the original logo, nor any of Adopte un mec's content. This website is up for a month every year at most, and you are free to use this code, but do not misuse it, or violate copyright laws associated with the original theme and logo, those are Adopte un mec's property.

## Authors

Implemented by [David ROBIN][http://www.sevis.pro/contact] with [Ruby on Rails][http://rubyonrails.org] on an original idea from Laura NGUYEN and Myriam QRICHI ANIBA.

Credits also go to Lison ABECASSIS and Florence GABORIT for their work in reporting bugs and giving advices that made this project awesome.
