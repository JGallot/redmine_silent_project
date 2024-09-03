module JournalPatch
  def self.included(base)
    base.send(:include, JournalExtraMethods)

    base.class_eval do
      alias_method  :send_notification, :send_notification_with_silence
    end
  end

  module JournalExtraMethods
    def send_notification_with_silence
      z_issue=Issue.find_by(:id=>self.journalized_id) unless self.journalized_type!="Issue"

      has_issue_changed = (Setting.notified_events.include?('issue_updated') ||
          (Setting.notified_events.include?('issue_note_added') && notes.present?) ||
          (Setting.notified_events.include?('issue_status_updated') && new_status.present?) ||
          (Setting.notified_events.include?('issue_assigned_to_updated') && detail_for_attribute('assigned_to_id').present?) ||
          (Setting.notified_events.include?('issue_priority_updated') && new_value_for('priority_id').present?) ||
          (Setting.notified_events.include?('issue_fixed_version_updated') && detail_for_attribute('fixed_version_id').present?)
      )

      Rails.logger.debug("notify : #{notify?}")
      Rails.logger.debug("has_issue_changed : #{has_issue_changed}")

      if notify? && has_issue_changed
        has_issue_status_changed         = new_status.present?

        # Get Silent statuses
        silent_statuses=ProjectSilent.where(:project_id => z_issue.project_id, :tracker_id => z_issue.tracker_id).pluck(:issue_status_id).to_a

        # Notify when going to new status OR when already at the silent status
        changed_to_silent_status         = (new_status.present? && silent_statuses && silent_statuses.include?(new_status.id) ) || (silent_statuses && silent_statuses.include?(z_issue.status_id))

        # should_notify_additional_changes not used for now but functionnality is kept ==> forcing to false
        should_notify_additional_changes = false
        Rails.logger.debug("has_issue_status_changed : #{has_issue_status_changed}")
        Rails.logger.debug("changed_to_silent_status : #{changed_to_silent_status}")
        Rails.logger.debug("should_notify_additional_changes : #{should_notify_additional_changes}")

        if has_issue_status_changed && changed_to_silent_status && !should_notify_additional_changes
          Rails.logger.debug ("Case 1 : NO MAIl")
          return false
        end

        if has_issue_status_changed && changed_to_silent_status && should_notify_additional_changes
          Rails.logger.debug ("Case 2 : send MAIL")
          Mailer.deliver_issue_edit(self)
          return false
        end
        unless changed_to_silent_status
          Rails.logger.debug ("Cas 3 : send mail")
          Mailer.deliver_issue_edit(self)
          return false
        end
      end
    end
  end
end

Journal.send(:include, JournalPatch)
