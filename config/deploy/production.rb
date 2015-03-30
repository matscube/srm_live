# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}
server 'web_server', user: 'ec2-user', roles: %w{app db web}, my_property: :my_value



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

namespace :deploy do

  desc "Start application"
  task :start do
    on roles(:app) do
      within release_path do
        execute :rake, %w(unicorn:start RAILS_ENV=production), raise_on_non_zero_exit: false
      end
    end
  end

  desc "Making assets files"
  after :cp_env_file, :make_assets do
    on roles(:app) do
      within release_path do
        execute :rake, %w(assets:precompile RAILS_ENV=production)
      end
    end
  end

  desc "Update DB"
  after :cp_env_file, :update_db do
    on roles(:db) do
      within release_path do
        execute :rake, %w(db:migrate RAILS_ENV=production)
      end
    end
  end

  desc "Stop application"
  task :stop do
    on roles(:app) do
      within release_path do
          execute :rake, %w(unicorn:stop), raise_on_non_zero_exit: false
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      within release_path do
          invoke 'deploy:stop'
          sleep 2
          invoke 'deploy:start'
      end
    end
  end
	
end

