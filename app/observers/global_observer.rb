class GlobalObserver
  def current_user
    # think about threading!!!
    Thread.current[:current_user]
  end
end