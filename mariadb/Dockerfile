FROM debian:bookworm

RUN apt update -y && apt upgrade -y

RUN apt install -y mariadb-server mariadb-client
#this is done to avoid conflicts when running mariadb
RUN rm -rf /var/lib/apt/lists/*


#replacing the mariadb server conf file with ours
RUN mkdir -p /etc/mysql/mariadb.conf.d

COPY my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf


#allowing mysql acces on the run folders
RUN mkdir -p /var/run/mysqld

RUN chmod 770 /var/run/mysqld/

RUN chown -R mysql:mysql /var/run/mysqld/


#readying for the script run
RUN mkdir /mymdbscriptfolder

COPY script.sh /mymdbscriptfolder/

EXPOSE 3306

CMD ["bash", "/mymdbscriptfolder/script.sh"]
