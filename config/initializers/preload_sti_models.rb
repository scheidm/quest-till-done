if Rails.env.development?
  %w[record link note image commit issue].each do |c|
    require_dependency File.join("app","models","#{c}.rb")
  end
end