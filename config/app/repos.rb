root = self.root

let :sessions do
  SessionsMemoryRepo.new do
    not_found_exception { root.exceptions.not_found }
  end
end
