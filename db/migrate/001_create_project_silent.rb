class CreateProjectSilent < ActiveRecord::Migration[6.1]
  def change
    create_table :project_silents do |t|
      t.references :project, index: true, foreign_key: true, null: false
      t.references :tracker, index: true, foreign_key: true, null: false
      t.references :issue_status,  :column => :issue_status_id, index: true, null: false, foreign_key: true
    end
  end
end
