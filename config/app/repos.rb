repos.let :sessions  do
  SessionsMemoryRepo.new do
    not_found_exception { app.exceptions.not_found }
  end
end
