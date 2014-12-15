let :sessions  do
  SessionsRepo.new do |r|
    r.not_found_exception { root.exceptions.not_found }
    r.let(:store) { {} }
    r.let(:mapper) do
      Inline.new do
        def load x; x; end
        def dump x; x; end
      end
    end
  end
end
