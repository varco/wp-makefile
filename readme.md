### Wordpress Makefile Workflow Example

This makefile automates the process of setting up a development environment from a shared Git repository. In this workflow, only your theme files are included with the projects. 

All dependencies, including Wordpress core and supporting plugins, are installed via the Makefile. It also bundles WP-Cli and PHPUnit in your project directory. 

This workflow is a work in progress and offers a lot of room for improvement.
Enjoy!

## Run the following shell commands locally:

### Add new DNS entry to local MAMP apache config

	nano /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

###### Example DNS entry
	<VirtualHost *:80>
		DocumentRoot "$HOME/Sites/variables-local/sites/project-name"
   		ServerName project-name.dev
	</VirtualHost>

### Point localhost to new local dev domain

	sudo nano /etc/hosts

###### Example domain

	127.0.0.1       project-name.dev

### Set-up working directory
	
	mkdir $HOME/Sites/variables-local/sites/project-name;
	DIR=$HOME/Sites/variables-local/sites/project-name;
	git clone git@github.com:username/example.git ${DIR};
	cd ${DIR};
	make;
	git config user.name "Your name";
	git config user.email "you@example.com";

	mysql -u root -p;
	CREATE DATABASE example_local;

## Run the following shell commands on dev server:

	ssh variable@eugene.dreamhost.com

	mysql -u 'user' -p;
	CREATE DATABASE example_dev;

## Run the following shell commands on staging/production:

	ssh user@remotehostingdomain.com

        mysql -u 'user' -p;
        CREATE DATABASE example_staging;
	CREATE DATABASE example_production;

###### Automated Install:

Run `make db` to configure wordpress, activate theme, plugins, and set options.


###### Final Steps:

* Log in to Wordpress via wp-admin.
* From Settings &rarr; Permalinks, set the structure to _Month and Name_. This also creates an .htaccess file for you.
* Import content from a production environment using a Wordpress WXR file. 
* Run `make test` to run unit tests.

