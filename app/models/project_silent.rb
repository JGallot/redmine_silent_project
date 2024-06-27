class ProjectSilent < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :project
  belongs_to :tracker
  belongs_to :issue_status

  def self.replace_statuses(project_id,silent_statuses_array)
    status_2_silent=silent_statuses_array.values.first

    tracker=Tracker.find_by(:id=>Integer(silent_statuses_array.keys.first))
    transaction do
      records = ProjectSilent.where(:project_id => project_id, :tracker_id =>tracker.id).to_a
      # Delete all records before injecting
      if records.size > 0
        records[0..-1].each(&:destroy)
      end
      # Add new silent Statuses
      status_2_silent.each do |status_id|
        status=IssueStatus.find_by(:id=>Integer(status_id))
        w=ProjectSilent.new(:project => project_id, :tracker=>tracker, :issue_status => status )
        w.save
      end
    end
  end
end
