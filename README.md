# Devops Helpers for Quickly Deploying Laravel Applications

There are two functions provided by this package:

1. Provisioning - Provision an Ubuntu 20.04 server with the necessary packages to run Laravel applications.
2. Deployment - Zero downtime deployment from a git based repository.

First clone this repo into the Ubuntu server where the Laravel application will be hosted.

### 1. Configuration
Before running either provisioning or deployments, the application configuration should be updated. Update the data in the `config.sh` file:

* `username` - This user will be created on the Ubuntu machine and will be used for deployment.
* `db_root_password` - This is the password for the root user.
* `deploy_directory` - The deployment directory. Suggest `/home/$username/web`
* `repo` - The git repository where the Laravel project exists.
* `app_domain` - The domain for the web application (e.g., `example.com`)
* `is_laravel` - A boolean indicating the project is Laravel based. Acceptable values: `true`, `false`


### Provisioning

