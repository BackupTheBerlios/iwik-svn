$__iwik_source_patterns = ['[A-Z]*', 'iwik', 'app/**/*', 'libraries/**/*', 'vendor/**/*']

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'iwik'
  s.version = "0.1"
  s.summary = 'An wiki based on Instiki'
  s.description = <<-EOF
    Iwik is an Instiki based wiki.
  EOF
  s.author = 'Denis Mertz'
  s.email = 'dmertz at online dot de'
  s.homepage = 'http://developer.berlios.de/projects/iwik/'

  s.bindir = '.'
  s.executables = ['iwik']
  s.default_executable = 'iwik'

  s.has_rdoc = true
  s.rdoc_options << '--title' << 'Iwik -- The Wiki' << 
                    '--line-numbers' << '--inline-source'
  # TODO: specify README as main RDoc file
  
  s.add_dependency('madeleine', '= 0.7.1')
  s.add_dependency('BlueCloth', '= 1.0.0')
  # s.add_dependency('RedCloth', '= 2.0.11')
  s.add_dependency('rubyzip', '= 0.5.8')
  s.requirements << 'none'
  s.require_path = 'libraries'

  s.files = $__iwik_source_patterns.inject([]) { |list, glob|
  	list << Dir[glob].delete_if { |path|
      File.directory?(path) or
      path.include?('CVS/') or 
      path.include?('vendor/RedCloth') or 
      path.include?('vendor/actionpack') or 
      path.include?('vendor/railties') or 
      path.include?('vendor/activesupport') or 
      path.include?('test/') or
      path.include?('_test.rb')
    }
  }.flatten

end
