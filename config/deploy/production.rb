role :app, %w{deploy@13.232.18.189}
role :web, %w{deploy@13.232.18.189}
role :db, %w{deploy@13.232.18.189}
set :stage, :production
set :rails_env, :production
set :deploy_user, "deploy"
server '13.232.18.189', user: 'deploy', roles: %w{web app db}, primary: true
# set :ssh_options, {
#   deploy: 'deploy',
#   forward_agent: false,
#   auth_methods: %w(password),
#   password: 'password'
# }
#
set :ssh_options, {
    user: 'deploy',
    forward_agent: false,
    auth_methods: %w(password),
    password: '1234'
}

# set :ssh_options, {
#     keys: %w(/Users/shubhamjain/Downloads/shubham_temp2.pem),
#     forward_agent: false,
#     auth_methods: %w(publickey)
# }








