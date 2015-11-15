Quest Till Done
[![Code Climate](https://codeclimate.com/github/scheidm/quest-till-done/badges/gpa.svg)](https://codeclimate.com/github/scheidm/quest-till-done)

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
* Setup Elastic Search:
  * install [elasticsearch](http://www.elasticsearch.org/overview/elkdownloads/)
    * $wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb
    * $dkpg -i elasticsearch-1.1.1.deb
    * $sudo /etc/init.d/elasticsearch start
* Setup for Redis
    * $sudo apt-get install redis-server
    * ``` this should start server by defualt ```
* Setup for Config File
* Setup for apache passenger


##Depolyment
There are many solutions, we suggest using Apache and Passenger Phusion


##Setup Notes *updated*

On Ubuntu Server
* Install using #apt-get install redis-server postgresql-server
* redis-server
* postgresql server
* elasticsearch start
* bundle exec sidekiq -d -L sidekiq.log -q mailer,5 -q default -e development

* change application.sample.yml to application.yml

