module PatioSessions
  module App
    Repos = Proc.new do

      tool :sessions do
        SessionsRepo.new.tap do |r|
          r.not_found_exception { root.exceptions.not_found }
          r.store { root.stores.default }
          r.mapper { root.mappers.generic }
        end
      end

    end
  end
end
