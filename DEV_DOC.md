_It is not necessary to read this file to run this project properly. This file is only for people looking to understand the process better, or wanting to make their own changes safely._

### User manual - advanced settings

## How does it work ?

First of all, let's explore how Docker is used a project like this. We'll need Docker images to build Docker containers, and Docker volumes to mount on those containers.

In short, here's how to build a Docker container from scratch.

# Docker images

First, we need an image. The image is the blueprint ; it tells the container what it needs, where to get it, and what to do when it starts running. An image can be used by multiple containers at once, since it isn't a dynamic object : once built from its Dockerfile, it is finished. To build an image, we write a Dockerfile. In this project, we start from debian:bookworm, or version 12, but it is possible to start from any image at all, including from scratch.

Our Dockerfile consists of a few command words :
- FROM (to pull the initial image.s)
- RUN (to run a specific command, like "apt install nginx")
- COPY (to copy host files into the container, like configuration files)
- WORKDIR (to specify a directory everything following will be executed from)
- EXPOSE (to expose a container port - this command does not create any connexion. It is for human readability.)
- CMD (the default command to execute upon container start)

The recipe for this project's Dockerfiles is simple : pull debian:bookworm, install the dependencies, create the directories, copy the configuration files where they need to go, copy the script to be run at container start, and run the script.

To build an image on its own, you can run :
> docker build ./path-to-the-dockerfile -t image-name:image-tag

To see a list of current images and their state, run :
> docker images -a

To remove a built image not currently in use in any container, run :
> docker image rm image_name

# Docker containers

From an image, you can then "run" a container, using the command (I've added the options used in this project, many more are available):
> docker run [--name container_name] [--env_file ./env_file_name] [--mount volume_name:/container_path] [-p host_port:container_port] [--network network_name] [--restart restart_policy] image_name

Any docker container can then be stopped and started with :
> docker stop container_name
and
> docker start container_name
respectively.

To see a list of current containers and their state, run :
> docker ps -a

To remove a stopped container, run :
> docker rm container_name

# Docker volumes

Docker volumes are, simply put, special Docker directories. Once mounted to a container, they function as permanent storage for the path they point to within that container.

To make a volume, run (again, options are limited to what we need in this project, for more check the official Docker documentation) :
> docker volume create [-d driver_name] [--opt specs] volume_name

To see a list of all current volumes, run :
> docker volume ls

To delete a volume, run :
> docker volume rm volume_name


_And now that we know how to make a container, let's find out how to make many of them at once, with even more ease and effiency._

# Docker compose

Docker compose is a wonderful tool designed to make a cross-container project as simple to manage as possible.

Building images, starting containers, creating networks and volumes, all in one convenient file and a few even more convenient commands.

Docker compose, like docker build, requires a blueprint in the form of a .yml file. Commonly named docker-compose.yml, it contains all the information one might put in the many, many options described above, about as many services (containers), volumes and networks as the project requires. I would explain how it works, but frankly I think reading it knowing what it does will explain it better.

Once the docker-compose.yml file is properly written, it comes with four practical commands.
> docker compose up [-d]
: builds every image, creates every volume, network and container. Also starts every container.
> docker compose stop
: stops every container.
> docker compose start
: starts every created container
> docker compose down
: stops and removes every container. (This command does not affect volumes or images, which must be removed individually as described in sections above.)

_Now you're caught up ! Let's find out what these tools can do for us._

## How do we use it ?

Plenty of tools at our disposal, now let's use them to run our local wordpress website.

This explanation will be divided in three sections : one for each container. I'll be specifiying which of the choices made are vital to the proper functioning of the project, and which are up to preference. Feel free to put your own twist on this project, or tweak it to fit your own needs.

# Mariadb

In the mariadb container, we first install mariadb (client and server), then create the relevant folders with the right permission.

We replace the original default configuration file with our own so that :
- databases are stored in /var/lib/mysql (subjective, dependent on the wp_db volume destination) ;
- it listens to the port 3306 (subjective, dependent on the wordpress DB_HOST variable) ;
- it listens to all ip addresses (objective).

In the script run on container start, we secure install the mariadb server, create the wordpress database and its user, then reboot the server so the changes take effect.

_There are other ways to do it. This is the one I chose._

The mariadb container is now running and operational. According to our docker-compose.yml, all the files it creates in /var/lib/mysql will be stored in the wp_db volume.

# Wordpress

In the wordpress container, we first install our php dependencies, mariadb (client), and a few download commands. We then download the wordpress files from the wordpress website and the wp-cli program from github. Once everything had been moved to its proper place (/var/www/html is the recommended directory for wordpress files) with the proper user permissions (www-data:www-data).

We replace the php-fpm configuration file with our own so that the group [www] :
- has user www-data from group www-data (I have not tried something else, but it seems possible, adjust permissions) ;
- handles its processes dynamically with a maximum of 5 at once (all of these variables are subjective, except at least one server is necessary) ;
- listens to 0.0.0.0:9000 (port subjective, dependent on the nginx fastcgi_pass).

In a script, we then write the wp-config.php file with all the relevant variables, before defining our url, admin user and additional user through wp-cli commands.

_There are many different ways to do this, including turning wp-sample-config.php into wp-config.php and doing the configuration on the website directly. This method was easier for me._

We then start php-fpm so it is ready to communicate with nginx.

Our wordpress container is running and operational. According to our docker-compose.yml, all the files from /var/www/html will be stored in the wp_site volume.

# Nginx

In the nginx container, things are very easy. We first install nginx and openssl, creating the necessary directories (this includes /var/www/html, as it is where the wp_site volume is mounted).

We add our configuration file so that our server :
- redirects requests to port 80 to our port 443 server (subjective) ;
- our server listens on 443 (subjective, dependent on the host:container ports) and has ssl enabled (recommended, not necessary) ;
- has a root of /var/www/html (subjective, dependent on the wp_site volume mount) ;
- has a fastcgi_pass of wordpress:9000 (port subjective, dependent on php-fpm listen in wordpress container) ;
- has the server name naorakot.42.fr (subjective, dependent on wordpress url).

We then create the ssl key-certificate pair for ssl certification and store them in the files from the configuration file (only needed for ssl enabled), before starting nginx.

Our nginx container is running and operational. According to our docker-compose.yml, it reads the wordpress files from /var/www/html, where wp_site is mounted, and communicates with the host through a 443:443 port pair.

## Where is everything ?

You might be wondering : where does the volume's data go ? And where do these containers get their identical variables from ?

Let's answer these questions.

# Volumes

Like mentioned before, volumes are Docker repositories, and not easily accessible unless it's through a container they are mounted on. Thankfully, our docker compose is here to save us once again.

You'll notice, for example, this line :
>volumes:
> wp_site:
>  driver_opts:
>   device: "/home/naorakot/data/site"

This is how we establish the volume:host_directory pair. As such, all the files stored from a container into this volume can be found in that host directory. Like magic !

This also means upon creation of the volume, if there were files in that directory, they are copied into the volume.[ maybe ]

# Secrets and Credentials

For this project, I've chosen to keep all my environment variables in one file that all my containers have access to. Any and all of these variables are fine to change for any reason, but remember to reset from scratch for the changes to take effect, and keep in mind the servers do not re-configure once they have the files they require to function. Best to restart with a clean slate.

To change this, simply amend in the docker-compose.yml, these lines :
>services:
> nginx:
>  env_file: .env

And add your own file there, with your own variables. Be careful to keep the names consistent with the files user by the container.

### Conclusion

And there you have it ! Go have fun.
