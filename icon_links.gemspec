spec = Gem::Specification.new do |s|
  s.name = 'icon_links'
  s.version = '0.1.1'
  s.summary = "Replace boring text links with sexy icons, with handy Rails icon_to helpers."
  s.description = "Replace boring text links with sexy icons, with handy Rails icon_to helpers."
  s.files = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb'] + Dir['examples/**'] + Dir['tasks/**/*.rake'] + Dir['bin/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.rubyforge_project = 'icon_links'
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'Icon Links -- Easily link with icons in Rails views'
  s.author = "Nate Wiger"
  s.email = "nate@wiger.org"
  s.homepage = "http://github.com/nateware/icon_links"
  s.requirements << 'activesupport v2.3.x'
  s.add_dependency('activesupport', '~> 2.3')
end
