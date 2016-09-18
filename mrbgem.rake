MRuby::Gem::Specification.new('mruby-redmine_activity') do |spec|
  spec.license = 'MIT'
  spec.author  = 'MRuby Developer'
  spec.summary = 'mruby-redmine_activity'
  spec.bins    = ['mruby-redmine_activity']

  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
end
