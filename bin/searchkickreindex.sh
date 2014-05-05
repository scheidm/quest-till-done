#!/bin/bash

bundle exec rake searchkick:reindex CLASS='Quest'
bundle exec rake searchkick:reindex CLASS='Record'

