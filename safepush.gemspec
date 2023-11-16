lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'safepush/version'

Gem::Specification.new do |spec|
  spec.name          = 'safepush'
  spec.version       = Safepush::VERSION
  spec.authors       = ['William Pollet']
  spec.email         = ['polletwilliam@gmail.com']

  spec.summary       = 'a small CLI that lints your code and'\
                       ' run your tests before you push'
  spec.homepage      = 'https://github.com/williampollet/safepush'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'i18n', '~> 1.6.0'

  spec.add_development_dependency 'bundler', '>= 1.16'
  spec.add_development_dependency 'fashion_police', '~> 1.2'
  spec.add_development_dependency 'pronto', '~> 0.9.5'
  spec.add_development_dependency 'pronto-rubocop', '~> 0.9.1'
  spec.add_development_dependency 'pronto-simplecov', '~> 0.1.1'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 0.60'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
end
