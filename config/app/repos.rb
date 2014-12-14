let :sessions  do
  SessionsRepo.new do |r|
    r.not_found_exception { root.exceptions.not_found }
  end
end
