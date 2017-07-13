# Adopte Un Spé

## Description

This is a website to choose godfathers for the newcomers in MPSI2.

It's built as a joke, and used during our first day of class, to welcome the new students. This is why it uses the famous [Adopte un mec](http://adopteunmec.com) theme. I _do not_ own the original logo, nor any of Adopte un mec's content. This website is up for a month every year at most, and you are free to use this code, but do not misuse it, or violate copyright laws associated with the original theme and logo, those are Adopte un mec's property.

Although it was originally built for LLG's MPSI2, this code can easily be adapted to any other godfather-choosing instance.

## Install

Just pull the code, and push to your production server. It is already Heroku-ready, more info on [Heroku Rails's starting page](https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction)

The following environnement variables need to be properly set : KEY\_SALT, SENDGRID\_USERNAME, SENDGRID\_PASSWORD

To set those in heroku for instance, just use

```
heroku addons:add sendgrid:starter
heroku config:set KEY_SALT=yoursalt
```

The sendgrid module sets the sendgrid variables automatically, and the starter addon is free of charges

The dictator key has to be set form the console.

You will also definitely want to edit the default welcoming e-mail : *app/views/user_mailer/welcome.html.erb*.

## Documentation

The [User Manual](doc/user_manual.md) and the [Administrator's Manual](doc/administrator_manual.md) should give you all the information needed to run this website properly.

If you have any questions about how this website works or how you could improve it, feel free to send me an e-mail

## Authors

Implemented by [David ROBIN](http://www.sevis.pro/contact) with [Ruby on Rails](http://rubyonrails.org) on an original idea from Laura NGUYEN and Myriam QRICHI ANIBA.

Credits also go to Lison ABECASSIS and Florence GABORIT for their work in reporting bugs and giving advices that made this project awesome.
