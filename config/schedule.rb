# Use this file to easily define all of your cron jobs.
#
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "/home/kevin/qtd_cron_log.log"
every 1.minutes do
  rake "searchkick:reindex CLASS='Quest'"
  rake "searchkick:reindex CLASS='Record'"
end
