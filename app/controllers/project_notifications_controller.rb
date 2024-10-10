class ProjectNotificationsController < ApplicationController
  before_action :authorize_global
  def index
    @project = Project.find(params[:project]) unless params[:project].nil?
    @silent_statuses=ProjectSilent.where(:project_id => @project).pluck(:tracker_id,:issue_status_id) unless !@project
    if not (@project.nil? || @project.trackers.nil? || !@project.trackers.empty?)
      flash[:error] = l(:error_no_tracker)
    end
  end

   def update
     if params[:project]
       @project_id=Project.find_by_identifier(params[:project])

       ProjectSilent.replace_statuses(@project_id,params[:silent_statuses])
       flash[:notice] = l(:notice_successful_update)
     end
     redirect_to_referer_or project_notifications_path
   end
 end
