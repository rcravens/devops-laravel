# Devops Platform for Quickly Deploying Laravel Applications

There are two features provided by this platform:

1. Server Provisioning - Provision an Ubuntu server with the necessary packages to run Laravel applications.
2. Application Management - Deploy multiple laravel applications to a single server and have **Zero Downtime Deployments** from a git based repository.

### Getting Started
There are two approaches to getting started:
1. Use the provided Amazon AWS CloudFormation stack to create your infrastructure in AWS.
<iframe width="560" height="315" src="https://www.youtube.com/embed/7xOpxpdLcfI?si=dQ1hvlgV-6gqkYxg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
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
Review, make changes for the desired configuration, and execute the `provision/provision_ubuntu_20_04.sh` script. This will 

