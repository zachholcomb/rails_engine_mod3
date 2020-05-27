# Rails Engine
  
This application is a REST API for the Rails Engine project for the Turing School of Software and Design.

 - Rails 5.1.7
 - Ruby 2.5.3
 
## First clone the repository and then run the following commands:

1. bundle (if this fails, try to bundle update and then retry)
1. rails db:create && rails db:schema:load
1. bundle exec rake db:seed:from_csv

Make sure your Rails Engine Database is seeded with the original data from the provided csv files
Make sure Rails Engine is serving from the url you specified in config/application.yml (localhost:3000 if you copied the example config/application.yml above)

## Front End
To see rails_engine in action with a front end, clone this repository https://github.com/turingschool-examples/rails_driver and follow the setup steps in that ReadME.


# Schema Design

![Untitled](https://user-images.githubusercontent.com/58053916/82973684-500a0980-9f95-11ea-96c2-8b719b07e65c.png)
