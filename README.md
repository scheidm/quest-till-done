Quest Till Done Project
-

In the spirit of [Habit RPG](https://habitrpg.com/static/front) and [Dungeons and Developers](http://www.dungeonsanddevelopers.com/), Quest Till  Done is a fun, visual task-management tool to help users juggle multiple projects, classes and/or hobbies.   
Rather than working through bland checklists, ascend project ‘talent trees’, gaining skill points in everything from cooking to python along the way. The product allows you to quantify your productivity and skill-set, while helping keep track of where you left off on each project in your ‘quest log’.  
Users can show off their achievements on their profiles in a social environment.


##Environment Requirement
* Ruby 2.1.1+
* Rails 4.0+
* PostgreSQL 8+

##Test Environment Setup
* Install rvm for ruby and rails   
* Run following commands:
  * $git clone https://github.com/scheidm/quest-till-done.git  
  * $cd quest-till-done  
  * $rails s
* Setup Searching:
  * install [elasticsearch](http://www.elasticsearch.org/overview/elkdownloads/)

##Depolyment
There are many solutions, we suggest using Apache and Passenger Phusion


##Setup

* redis-server
* postgresql server
* elasticsearch start
* bundle exec sidekiq -e development

