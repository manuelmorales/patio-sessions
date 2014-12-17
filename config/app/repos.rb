let :sessions  do
  SessionsRepo.new do |r|
    r.not_found_exception { root.exceptions.not_found }
    r.let(:store) { root.stores.default }
    r.let(:mapper) { root.mappers.generic }
  end
end
