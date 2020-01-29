# role :app, %w{deploy@13.232.18.189}
# role :web, %w{deploy@13.232.18.189}
# role :db, %w{deploy@13.232.18.189}
# set :stage, :production
# set :rails_env, :production
# set :deploy_user, "deploy"
# server '13.232.18.189', user: 'deploy', roles: %w{web app db}, primary: true
# # set :ssh_options, {
# #   deploy: 'deploy',
# #   forward_agent: false,
# #   auth_methods: %w(password),
# #   password: 'password'
# # }
# #
# # set :ssh_options, {
# #     user: 'deploy',
# #     forward_agent: false,
# #     auth_methods: %w(password),
# #     password: '1234'
# # }
#
# set :ssh_options, {
#     keys: %w(/Users/shubhamjain/Downloads/shubham_temp2.pem),
#     forward_agent: false,
#     auth_methods: %w(publickey)
# }



# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
set :branch, "master"
set :stage, :production
# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.
# server '128.199.100.119',
#   user: 'root',
#   roles: %w{web app}
server '13.232.18.189',
       user: 'deploy',
       roles: %w{web app db}







