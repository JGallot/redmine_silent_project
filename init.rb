Redmine::Plugin.register :redmine_silent_project do
  name 'Redmine Silent Project plugin'
  author 'Jérôme Gallot'
  description 'This plugin provides functionality to disable notifications when changing status.'
  version '0.2'
  author_url 'https://github.com/JGallot'

  permission :admin_project_notifications, { project_notifications: [:index, :update] }
  menu :project_menu, :project_notifications, { controller: :project_notifications, action: :index }, caption: :notifications, after: :settings, param: :project

end

Rails.application.config.after_initialize do
  include SilentProjectHelper
  include JournalPatch
end
