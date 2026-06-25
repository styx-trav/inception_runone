_If you haven't read the Instructions section of the README.md, please read it first._

### User manual

Welcome ! Now that you have everything you need, let's navigate this project.

## Project overview

This project is made up of three services, each run in their own Docker container.

# Nginx

Nginx is an HTTP server through which any number of servers can be run. It handles the clients' HTTP requests and returns the appropriate information, as well as running dynamic files through their cgi handler (here, php).

In this project, it is running from the nginx container, connected to the host through port 443 with ssl enabled. It connects to php-fpm through the docker network on port 9000 and accesses Wordpress files through its mounted volume wp_site.

# Wordpress

Wordpress is a customizable blogging website, easily downloadable from their official site. It is made up of mostly dynamic .php pages and connected to a database for information storage.

In this project, it is downloaded and configurated in the wordpress container, which runs php-fpm to execute .php files at the request of the nginx container through the bridge on port 9000. Its files are kept in the mounted volume wp_site, and it connects to its database on the mariadb container through the docker bridge on port 3306.

# Mariadb

Mariadb is a database manager derived of MySQL. It manages requests to read, add, edit and erase information from the databases it oversees.

In this proect, it is running from the mariadb container, connected to the wordpress container through the Docker network on port 3306, as is standard, and stores its files in the volume wp_db.

## How to...

# Get it running

First, ensure Docker is installed and running (you can use the command "systemctl start docker"), and this repository is cloned on your computer with the environment variables filled out. If this is not the case, please refer to the Instructions section of the README.md before doing anything.

Now, as root and at the root of this repository, run :
> make up
to create and start all three containers. To stop and start these containers, run :
> make stop
and
> make start
respectively. If the goal is to remove the containers entirely, run :
> make down
, however keep in mind you will need to create these containers before starting them again.

# Check services

In order to ensure all is running as it should be, a couple useful commands :
> docker ps -a
: lists every created container and whether it is currently running. There should be three : wordpress, mariadb and nginx. They should all be running.
> docker images -a
: lists every built image and if it is currently in use. There should be three, and they should all be in use.
> docker volume ls
: lists every Docker volume. There should be two : wp_site and wp_db.

# Manage credentials

Every user, password and name is kept as an environment variable in .env, at the root of the respository. Feel free to change or use them as you wish, but don't forget to rebuild when you do so you can see the changes.

# Access the site

Congratulations, everything is running smoothly !

You can now access the local Wordpress website. Open a browser of your choice and search the url https://naorakot.42.fr (or localhost, as you will be redirected).

If the browser issues a warning about the authenticity of the ssl certificate, you may ignore it. This is caused by the fact that our ssl certificates are self-authenticated and therefore not approved by a recognized authority.

This url should direct you to the inception blog, functional but empty. To start blogging, add /wp-admin to the url and log in as one of the two users already created (credentials in the .env file). This should redirect you to an editing page.

And that's it ! Happy blogging.
