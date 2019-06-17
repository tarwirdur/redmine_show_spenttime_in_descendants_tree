require 'show_spenttime_in_descendants_tree/IssuesHelperPatch'

Redmine::Plugin.register :redmine_show_spenttime_in_descendants_tree do
  name 'redmine_show_spenttime_in_descendants_tree plugin'
  author 'Tarwirdur Turon'
  description 'Adds spent time and estimated time into descendants tree in issue'
  version '0.0.1'
  url 'http://github.com/tarwirdur/redmine_show_spenttime_in_descendants_tree'
  author_url 'http://github.com/tarwirdur'
end
