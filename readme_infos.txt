README ::
	the line, in italics
this project consists of three main new concepts :
	docker and database management
to learn these new concepts, the project requires us to create and run three docker containers, each containing a piece of the process :
	nginx, to run the server
	wordpress and php, to run the cgi on .php sites
	mariadb, to manage the wordpress database
		all connected together through a docker network

in order to run this project, you need to clone this repository on a virtual machine with docker installed. to install docker, feel free to follow the official instructions on the docker website. once the files are installed, don't forget to add an .env file, filling in the environment variables specified in the env_vars.txt file.
after that, to create and start the containers, run "make up"
to stop and delete the containers, run "make down"
to start the already existing containers, run "make start"
to stop existing containers without deleting them, run "make stop"
while the containers are up and going, open a browser of your choice and type in "https://naorakot.42.fr" or "localhost" to access the local wordpress website ! go to /wp-admin if you want to log in and edit the blog or post new content.

resources include :: the two youtube videos, malatini's version, that other version, the wp-config.php website, the docker website, the mariadb website, the wordpress debian install website, etc. AI was used twice to diagnose small issues with my installation.

docker !!! its a process manager :: you can set up containers with only the dependencies required for the project to work, without the bulk and latency of a complete virtual machine. its designed to deal with issues like program compatibility and, like a vm, contains the consequences of your programs to a restrained environment.

vm v docker :: a virtual machine behaves just like a smaller computer. it requires an operating system of its own and is an isolated system. docker manages containers, which share the kernel of the host computer. docker containers are much lighter than virtual machines, and interconnected through the docker management. they are, however, much less secure, caused primarily by docker's need for root access and use of the host's resources. it is recommended and standard to run your docker containers in a virtual machine for a more secure installation.

secrets v env vars :: secrets are a developer's best friend : they keep your private information, private ! sharing platforms like github and docker (i forget the name, but that) are great for collaborative work and publicly accessible repositories or images, but your own confidential informations (user-password pairs, API keys, ssh keys, etc.) should never be shared. to remedy this security risk, these variables are often kept locally/securely as environment variables, easy to switch out and access, out of public view. often, in a docker or git repository, there will be a specific file (gitignore, dockerignore) to keep track of files to exclude from publishing, where secrets may be stored.

docker network v host network :: there are multiple types of docker networks, but the one used in this project is called a bridge. it's a network that belongs to docker and allows inter-container communication, but no outside connection. the host network is separate from this, and is consists of the ports available from the computer itself. as such, in this project, when the nginx container connects to wordpress:9000, it is on the docker network and does not affect port 9000 on the host machine. when nginx connects to its 443 port, however, as set up in the docker compose, it reaches out to the host port 443. that is what allows the web page information to travel from the nginx container to the web browser, which is running outside of docker and is therefore out of reach of the docker bridge network. it is also possible to set up docker containers on the host network directly, but it is not recommended.

docker volumes v bind-mounts :: docker volumes and docker bind-mounts both seek to by-pass a docker container feature - files deletion. when a container is stopped and deleted, all the files it created and edited are deleted with it. to circumvent this, any files one wishes to store more permanently (like a database) must be stored in a docker volume or bind-mounted onto the host file management system. a bind-mount simply redirects all the files to the host folder it was mounted on, while a volume is managed by docker. the files stored in the volume are kept by docker and as such accessible by connecting a container to it. to be able to access these files more easily and while docker isn't running, or to keep the files intact even when the volumes are deleted, one can assign a host folder to the volume, allowing the files to be stored locally. this differs from a bind-mount 

USER_DOC.md ::
	a line to say this is for users
in order to start this project, you must have docker installed and running on your machine. clone this repository, fill in the environment variables, and at the root, run make up. doing so will create and start three interconnected containers each hosting, respectively, nginx (our server), wordpress and php-fpm (our website and cgi), and mariadb (our website database). collectively, they allow the smooth running of a local wordpress website server, with two users already in place.
to stop this server, run make stop, and to start it again, make start. if you want to stop and delete the docker containers, run make down, but beware you'll have to run make up to create them again.

to access the website, ensure the containers are running and connect to localhost/naorakot.42.fr on any browser. ignore the security warning (this warning is caused by the fact that our ssl certificates are not authenticated by a recognized authority but rather by ourselves). to make edits, comments or new posts, add /wp-admin to the url and connect using the credentials chosen for the admin and user in the wordpress configuration. every credential can be found in the .env file uner the relating name.

to check if the containers are running, run docker ps -a to see ht elist of active containers and their current state. you can also check the docker images by running docker images -a for a list of their state. if you need to check on the volumes, run docker volume ls. otherwise, connect to the website and if any error happens, you can check the wordpress logs in /wp-content/debug.log.

DEV_DOC.md ::

possible re-configuration ::
	changing the server/domain name :: in /nginx/my.conf (as well as the ssl files in /nginx/script.sh); in /wordpress/script.sh wordpress core install; in the host machine /etc/hosts file next to 127.0.0.1
	wordpress advanced settings :: in /wordpress/script.sh, add or delete your changes (like the language WP_LANG, or the debug display option to true) in the wp-config.php file before re-creating the image, add more users with the wp user create command, etc.
	php-fpm advanced settings :: in /wordpress/www.conf, edit the values for the initial amount of servers to start, the max amount of servers, and the spare servers available.
	nginx advanced settings :: in /nginx/my.conf, edit the ssl ciphers, ssl certificates or even the ports used by the server
	mariadb advanced settings :: in /mariadb/my.cnf, edit the folder where the database files are kept, or the port to listen to
	
	port specific changes ::
		nginx - wordpress (/nginx/my.conf, in location ~ \.php { fastcgi_pass } ; /wordpress/www.conf, in listen = )
		mariadb - wordpress (/mariadb/my.cnf, in port = ; /wordpress/script.sh, in wp-config.php, in define( 'DB_HOST', ' ' ))
		nginx - host (/nginx/my.conf, in server { listen ''; } ; docker-compose.yml, in nginx: ports: - '':'')
	
	any other change :: edit environment variables

build and launch with make up, then stop and start with make stop, make start, and to remove containers, run make down
more commands you might want to use ::
	docker rm [] (delete a container)
	docker images -q (see the built images and their current state)
	docker image rm [] (delete an image)
	docker build [./path to dockerfile] (build the image based on the dockerfile provided)
	docker volume rm [] (delete a volume)
	docker exec -it [container] bash -c '[cmds]' (run a/mult commands in a running container, for example to check everything is running well)

where is data stored :: in docker-compose, the volumes have a driver_opts:device parameter, which stipulates where on the host machine the files from that volume are kept. the database volume is called wp_db, and the website volume is called wp_site. to see debug logs, check wp_site/wp-content/debug.log and wp_db/debug.log
