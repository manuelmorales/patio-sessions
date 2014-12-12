let :sessions  do
  SessionsMemoryRepo.new do |r|
    r.not_found_exception { root.exceptions.not_found }
  end
end
