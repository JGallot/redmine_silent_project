# Silent Project Redmine plugin

This plugin disables/mutes email notifications on specific status(es) per project.

This plugin is inspired by the Redmine silent status plugin

Beware :
* This plugin work on current project not on sub projects 
* "Tested" only in Redmine 5.0.X  

## Installation

1. Clone this plugin to your Redmine plugins directory:

```bash
git clone git@github.com:JGallot/redmine_silent_project.git
```

2. Run Redmine plugin database migration (in redmine directory)
```bash
bundle exec rake redmine:plugins:migrate NAME=redmine_silent_project RAILS_ENV=production
```

3. Restart Redmine, and check that plugin is available on the Plugins page.

## Usage

Go to a project with admin rights, you should see a new module names notifications


