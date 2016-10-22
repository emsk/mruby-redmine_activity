require_relative 'mrblib/mruby-redmine_activity/version'

MRuby::Gem::Specification.new('mruby-redmine_activity') do |spec|
  spec.license = 'MIT'
  spec.author  = 'emsk'
  spec.version = MrubyRedmineActivity::VERSION
  spec.summary = "Summarize one day's activities on Redmine."
  spec.bins    = ['mruby-redmine_activity']

  spec.add_dependency 'mruby-print', core: 'mruby-print'
  spec.add_dependency 'mruby-mtest'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-httprequest'
  spec.add_dependency 'mruby-onig-regexp'
  spec.add_dependency 'mruby-polarssl'
end
