class RunnerWorker
  include Sidekiq::Worker
  def perform(id)
    sleep 10
    puts "======================================================#{id}==========================================================================="
  end
end