-starter-theme wp-content/themes/PHONY:  install

install: clean wordpress phpunit wp-cli set-up
	script;
	git submodule init;
	@echo "\n\nNOTICE: You may need to configure a MySQL database for your Wordpress installation. Just run:"
	@echo " mysql -u root -p;"
	@echo " CREATE DATABASE example_site; \n"

wordpress: latest.tar.gz	
	tar -zxvf latest.tar.gz;
	rm -rf wordpress/wp-content;
	mv wordpress/* ./;
	rm -rf latest.tar.gz wordpress license.txt readme.html wp-content/plugins/akismet wp-content/plugins/hello.php;
	mkdir -p wp-content/plugins;

latest.tar.gz: 
	curl -LOk http://wordpress.org/latest.tar.gz;

set-up:
	@printf 'What is the project slug? (e.g. cameronsbrewing, osler, gocactus): '; \
	read SLUG_VAR; \
	wp core config --dbhost=127.0.0.1:8889 --dbname=gocactus_local_$$SLUG_VAR --dbuser=root --dbpass=root; \
	wp core install --url="http://$$SLUG_VAR.dev" --title="$$SLUG_VAR" --admin_name=vars_co --admin_email=info@thevariables --admin_password=pasword123;
	mkdir wp-content/themes;
	git clone git@bitbucket.org:gocactus-inc/gocactus-starter-theme.git;
	mv gocactus-starter-theme wp-content/themes/
	wp theme activate gocactus-starter-theme;
	wp plugin install wp-less add-to-any advanced-access-manager advanced-custom-fields custom-post-type-ui duplicate-post google-analytics-dashboard-for-wp googleanalytics mailchimp mailchimp-for-wp regenerate-thumbnails relevanssi rest-api simple-301-redirects svg-support taxonomy-terms-order theme-check updraftplus welcome-email-editor wordpress-seo wp-all-import wp-optimize yoast-seo-acf-analysis --activate;
	wp rewrite structure "/%year%/%monthnum%/%postname%/";
	

wp-cli:
	mkdir -p wp-cli && cd wp-cli;
	curl -LOk https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
	php wp-cli.phar --info	
	chmod +x wp-cli.phar;
	sudo mv wp-cli.phar /usr/local/bin/wp;
	ln -s ./wp-cli/bin/wp wp

phpunit:
	curl -LOk http://pear.phpunit.de/get/phpunit.phar;
	mv phpunit.phar phpunit;
	chmod +x phpunit;

test:
	./phpunit

clean: 
	rm -rf wp-admin wp-includes readme.html license.txt .htaccess wp-activate.php wp-config-sample.php wp-login.php wp-trackback.php wp-blog-header.php wp-cron.php wp-mail.php wp-comments-post.php wp-links-opml.php wp-settings.php wp-load.php wp-signup.php xmlrpc.php index.php;
	rm -rf latest.tar.gz wordpress;
	rm -rf wp wp-cli phpunit;

deploy:
	git checkout master && git merge development && git checkout development && git push --all

help:
	@echo "Makefile usage:"
	@echo " make \t\t Get Wordpress application files"
	@echo " make clean \t Delete Wordpress files"
	@echo " make test \t Run unit tests"
	@echo " make deploy \t Merge development branch into master and push all"
