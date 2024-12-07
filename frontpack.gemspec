# frozen_string_literal: true

require_relative 'lib/frontpack/version'

Gem::Specification.new do |spec|
  spec.name        = 'frontpack'
  spec.version     = Frontpack::VERSION
  spec.authors     = ['Francis Schiavo']
  spec.email       = ['francischiavo@gmail.com']
  spec.homepage    = 'https://github.com/francis-schiavo/frontpack'
  spec.summary     = 'A pack containing useful front-end features.'
  spec.description = 'A pack containing useful front-end features.'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/francis-schiavo/frontpack'
  spec.metadata['changelog_uri'] = 'https://github.com/francis-schiavo/frontpack/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'importmap-rails', '~> 2.0'
  spec.add_dependency 'rails', '>= 7.1.3.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
