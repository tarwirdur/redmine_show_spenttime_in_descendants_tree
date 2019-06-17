require_dependency 'issues_helper'

module IssuesHelperPatch
  def self.included(base) 
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method :render_descendants_tree_without_patch, :render_descendants_tree
      alias_method :render_descendants_tree, :render_descendants_tree_with_patch
    end
  end

  module InstanceMethods
    def render_descendants_tree_with_patch(issue)
      s = '<table class="list issues odd-even">'
      issue_list(issue.descendants.visible.preload(:status, :priority, :tracker, :assigned_to).sort_by(&:lft)) do |child, level|
        css = "issue issue-#{child.id} hascontextmenu #{child.css_classes}"
        css << " idnt idnt-#{level}" if level > 0
	row = ''

        row << content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox') +
                 content_tag('td', link_to_issue(child, :project => (issue.project_id != child.project_id)), :class => 'subject', :style => 'width: 50%')
        row << content_tag('td', h(l_hours(child.total_spent_hours)) + "/" + h(child.estimated_hours)) unless issue.disabled_core_fields.include?('estimated_hours') || !User.current.allowed_to?(:view_time_entries, issue.project)
        row << content_tag('td', h(child.status), :class => 'status') +
                 content_tag('td', link_to_user(child.assigned_to), :class => 'assigned_to') +
                 content_tag('td', child.disabled_core_fields.include?('done_ratio') ? '' : progress_bar(child.done_ratio), :class=> 'done_ratio') +
                 content_tag('td', link_to_context_menu, :class => 'buttons')
        s << content_tag('tr', row.html_safe, :class => css)
      end
      s << '</table>'
      s.html_safe
    end

  end
end

IssuesHelper.send(:include, IssuesHelperPatch)
