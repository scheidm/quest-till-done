#!/bin/bash

WORKDIR=/home/ubuntu/senior/quest-till-done
REPO=git@bitbucket.org:scheidm/quest-till-done.git
BRANCH=micro-prototype
PORT=1000
cd $WORKDIR
PID=$(cat $WORKDIR/tmp/pids/server.pid)
sudo kill -9 $PID
git stash
git pull $REPO $BRNACH
rake db:migrate 
bundle install
rvmsudo rails server -p $PORT
