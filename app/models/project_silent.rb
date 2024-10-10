class ProjectSilent < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :project
  belongs_to :tracker
  belongs_to :issue_status

  def self.replace_statuses(project_id,silent_statuses_array)
    unless silent_statuses_array.nil?
      silent_statuses_array.each { | id_tracker, config_tracker|
        status_2_silent=config_tracker

        tracker=Tracker.find_by(:id=>id_tracker)

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
      }
      # Clean trackers with no config
      # Get all Project Trackers
      all_project_trackers=project_id.trackers.pluck('id')
      all_project_trackers.each do |tracker_id|
        unless silent_statuses_array.keys().include?(tracker_id.to_s())
          # Tracker not found in parameters, delete all records
          transaction do
            records = ProjectSilent.where(:project_id => project_id, :tracker_id =>tracker_id).to_a
            if records.size > 0
              records[0..-1].each(&:destroy)
            end
          end
        end
      end
    else
        # nil? so Delete all records
        transaction do
          records = ProjectSilent.where(:project_id => project_id).to_a
          # Delete all records before injecting
          if records.size > 0
           records[0..-1].each(&:destroy)
          end
        end
    end
  end
end
