# Devops Platform for Quickly Deploying Laravel Applications

There are two features provided by this platform:

1. Server Provisioning - Provision an Ubuntu server with the necessary packages to run Laravel applications.
2. Application Management - Deploy multiple laravel applications to a single server and have **Zero Downtime Deployments** from a git based repository.

### Getting Started
There are two approaches to getting started:
1. Use the provided Amazon AWS CloudFormation stack to create your infrastructure in AWS.

Here is a "how to" video for the CloudFormation deployment (released: April 19):

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/7xOpxpdLcfI/0.jpg)](https://www.youtube.com/watch?v=7xOpxpdLcfI)

2. If you have an existing server, then clone this repo into the Ubuntu server where the Laravel application will be hosted. Be sure to clone into a directory that is accessible by all users (e.g., /usr/local/bin/deploy )

### Provisioning
1. First update the `db_root_password` and `php_version` in the `./config.sh` file
2. Update the `./provision/provision_ubuntu_20_04.sh` script to include the packages you want by uncommenting the code
3. Run the `./provision/provision_ubuntu_20_04.sh` script

Here is a "how to" video for the provisioning (released: April 23):

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/abYcW8KjV3s/0.jpg)](https://www.youtube.com/watch?v=abYcW8KjV3s)

### Application Management
If the following commands are not available, run the `./common/create_aliases.sh` script to create the aliases in your bash profile. You may need to "re-source" to make those work.

As the root user should have the following commands available to you:
* `appList` - Lists out the installed applications. You can have multiple applications installed on a single server (e.g., demo_1, demo_2...)
* `appNew` - This command collects the necessary information to create a new application. You will need to provide the following:
  * Deployment Username - Each application has its own deployment user. This will also become the application name and the MySQL database name. (e.g., demo_1)
  * Deployment User Password - Password for the deployment user's account
  * Deployment User MySQL Password - Each deployment user can only access the database associated with their application.
  * Application Port Number - Nginx will serve up multiple applications on a single server, but each will need a distinct port number.
  * Git Repo Url - Provide the URL used by the `git clone` command to download the code for the application.
  * Public SSH Key - This is the public key of a local key pair. Providing this public key allows you to SSH into the serve as the deployment user.
* `appCreate <app_name>` - This command setups up the environment (e.g., deployment user, MySQL, git) to support the new application. This is a two pass approach:
  * First Pass - The first time you run, you will be provided an SSH Key that you should copy/paste as a deployment key in your Git Repo. This allows this deployment user to access the application repo.
  * Second Pass - The second time you run the command, the application will be deployed
* `appDelete <app_name>` - This command will delete **ALL DATA** associated with the application.

Here is a "how to" video for application management (released April 26):

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/hK04PYM2X58/0.jpg)](https://www.youtube.com/watch?v=hK04PYM2X58)

### Release Management / Deployment
Once you have an application deployed, you will have the following available to you **as the deployment user**:
* `deploy` - This alias kicks off a deployment. Each release is created in a separate directory and once the release is read (e.g., cloned, built, ...) then the symlink that Nginx uses is updated to point at the new release.

Here is a "how to" video for release management (release April 30):

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/sIkHxdaxnn4/0.jpg)](https://www.youtube.com/watch?v=sIkHxdaxnn4)
