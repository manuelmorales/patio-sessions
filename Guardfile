scope groups: [:test]

group :test do
  options = {
    all_after_pass: true,
    all_on_start: true,
    cmd: './cli test',
  }

  guard('rspec', options) do
    watch(%r{(lib/.*|config/.*|spec/.*)\.rb}) do |f|
      'spec'
    end
  end
end

