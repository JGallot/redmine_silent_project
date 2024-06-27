module SilentProjectHelper
  def redmine_silent_statuses_list_of_active_statuses
    allStatuses = IssueStatus.all.sorted
  end
  def redmine_silent_statuses_active_statuses (tracker)
    allStatuses=tracker.issue_statuses
  end
end
