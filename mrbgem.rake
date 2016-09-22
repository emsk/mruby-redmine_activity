MRuby::Gem::Specification.new('mruby-redmine_activity') do |spec|
  spec.license = 'MIT'
  spec.author  = 'emsk'
  spec.summary = 'Summarize activities on Redmine.'
  spec.bins    = ['mruby-redmine_activity']

  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-httprequest'
  spec.add_dependency 'mruby-onig-regexp'
end
