_This project has been created as part of the 42 curriculum by naorakot._

### Inception

## Description

This project introduces two main new concepts : docker, and database management.

To learn and master these new concepts, the goal is to create and run three docker containers, each hosting a piece of the process :
- nginx : to run the server and make the wordpress website accessible through a browser;
- wordpress and php : to install, store and process all wordpress .php files;
- mariadb : to manage the wordpress database.

Finally, the project indicates a docker network must be created so all these containers can properly communicate.

## Project description

# VM v Docker

First, what is Docker ? Docker is a process manager. It allows for the creation and use of containers with restrained, clean environments - ideal for software development projects, and lightweight. Docker itself and every container it creates and runs exist on the host machine - it does not, like a virtual machine, run on its own OS as a separate entity.

A VM is essentially a smaller computer installed on a bigger computer : less resources, same functioning. Docker is not. It runs on the host kernel and uses host resources - that is why it requires root access to work.

This makes Docker much, much faster than any virtual machine - but also far less secure. Despite being run in a docker container, malware can escape containment and has root permission to edit the files and processes necessary to the running of the host. It is also incompatible with many firewalls, which makes the hosting machine more vulnerable.

A virtual machine will simply crash or malfunction, without disturbing the functioning of its host.

In conclusion, Docker is very efficient at running dependency-sensitive, safe processes. A virtual machine is slower, but significantly more separate from the host, and much safer for malware-prone testing. Both can be very useful as production environments, and in this project we use them in tandem - and reap every benefit.

# Secrets and environment variables

"Secrets" is a development umbrella term used to refer to confidential or pivileged information : for example, an ssh or API key, or user credentials.

Environment variables, as the name indicates, are variables stored in the environment of a project. This makes them easy to manipulate (one change instead of many), easy to use (no need to remember every 378 character long API key), and mostly, hidden. In other files, they appear only as their variable name, often named after their uses.

Secrets are often - though not always - kept out of view as environment variables in "hidden" files or folders, and for good reason.

Platforms like GitHub and Docker are very useful for collaborative work and project publishing, but they are things about a project that need to stay private. Keeping these things as environment variables and adding those files to a .git-ignore or .docker-ignore list gives a developer the peace of mind to publish without fearing the misuse of their credentials.

# Docker network v Host network

Docker containers, like the host, each have their own ports to which they can connect. these ports can connect to each other through a docker network - in this project, they are connecte through the default bridge network, kept separate from the host. As such, when the nginx container sends to wordpress:9000, it is requesting a connexion through the docker bridge to the wordpress container, on port 9000. This port is not on the host network and does not affect the host port 9000, in fact the interaction does not go through the host network at all.

The host network is comprised of the ports available on the host machine. In this project, for example, the nginx container connects to it through its port 443. The docker-compose.yml file explicitly creates this connection between the nginx 443 port and the host 443 port ; it would not exist otherwise. This is done so the server can communicate with web browsers, which are host-dependent and therefore entirely separate from docker.

Docker allows for a/multiple container.s to connect directly on the host network through configuration, but this can lead to conflicts if for example the host is already using them or they are significantly safeguarded, and it's often entirely unnecessary.

For this project, the only host connexion necessary is the nginx server communicating with host port 443. Every other connexion is container to container and should therefore go through a docker network (here, the bridge).

# Docker volumes v bind-mounts

When a docker container is stopped and deleted, every file it created or edited is deleted with it. This can sometimes be troublesome, so to bypass the issue, one can use docker mounts and volumes.

A bind-mount mounts a container path directly onto a host path. This path is now where the container files will be stored, accessed and edited. Upon deletion of the container, these files will persist and be accessible directly through the host file management system. Docker does not keep or manage a copy of these files.

A Docker volume is a directory owned and managed by Docker to store a/multiple container.s data. Docker creates it, manages it, and, if prompted, deletes it. It is not kept in the host file management unless specified.

For this project, two Docker volumes are used, each paired with a host directory. Docker manages these volumes, but their files are accessible through the host directory they are paired to. This way, container files persist across iterations, and are easily accessible through the host file management.

The main difference for our use is that a volume mapped onto a host directory will use the files already present in it, where a bind-mount will only be able to ignore them.

## Instructions

To compile and run this project, one needs :
- docker (feel free to follow the installation recommended by the docker website [link-text]https://docs.docker.com/engine/install/) ;
- root access, as docker requires it to function ;
- this repository, cloned onto their host machine ;
- existing /home/naorakot/data/site and /home/naorakot/data/sql directories.

Once everything is on their machine, they should fill out the environment variables in env_vars.txt with credentials and names of their choosing, then rename the file ".env".

_To use proper wordpress keys, go to_ [link-text]https://api.wordpress.org/secret-key/1.1/salt/ _and copy paste the keys in order ; less securely, any varied phrases will do._

Now that everything is installed, open a terminal as root at the root of this repository, and run :
> make up
to create and run all three containers, as well as the two volumes. To manage the containers once they are created, use :
> make stop
and
> make start
to stop and start the containers. To completely remove the containers (but not the images they are using), run :
> make down

That's it ! While the containers are running, the website will be accessible for browsing or edits.

## Resources

[link-text]https://docs.docker.com (for Docker documentation, installation, commands, syntax, etc.)
[link-text]https://mariadb.com/docs/server/reference/sql-statements (for mariadb statement syntax)
[link-text]https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://www.youtube.com/watch%3Fv%3DDQdB7wFEygo&ved=2ahUKEwjC1fPioqKVAxW1BfsDHR0FNLMQtwJ6BAgUEAI&usg=AOvVaw0WqCEcdZ2NrSmhR1L2WNRQ (to understand Docker itself)
[link-text]https://github.com/malatini42/inception (for his elegant use of the wp commands to configure the wordpress blog, and the databse connexion checks)
[link-text]https://blog.o2switch.fr/configurer-wp-config-php-wordpress/ (for the wordpress configuration file, and the wordpress key API link)
[link-text]https://nginx.org/en/docs/http/configuring_https_servers.html (to properly configure the nginx ssl)
[link-text]https://nginx.org/en/docs/beginners_guide.html (to properly configure nginx fastcgi for php)
[link-text]https://github.com/wp-cli/wp-cli (to install the wp command and use it easily)

AI was used twice to diagnose small issues with my mariadb installation.
