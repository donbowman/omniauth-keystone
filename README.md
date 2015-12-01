omniauth-keystone
=================

see https://github.com/donbowman/omniauth-keystone for code

OmniAuth strategy for OpenStack keystone

- Stop GitLab:
  - `sudo service gitlab stop`
- place graphics in the vendor/assets/images/authbuttons directory
- Add keystone as one of the default providers in the default_providers() function of the app/helpers/oauth_helper.rb file
- Add a section for keystone in config/gitlab.yml with the client_id and client_secret
- Added omniauth-keystone strategy to the Gemfile file
- Installed the gem from the GitLab root directory using
  - `sudo -u git -H bundle install --without development test postgres --path vendor/bundle --no-deploy`
- Precompile the assets from the GitLab root directory using
  - `sudo -u git -H rake assets:precompile RAILS_ENV=production`
- Start GitLab
  - `sudo service gitlab start`
