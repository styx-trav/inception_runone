FROM debian:bookworm

RUN apt update -y && apt upgrade -y

RUN apt install -y mariadb-server mariadb-client

RUN rm -rf /var/lib/apt/lists/*


RUN mkdir -p /etc/mysql

COPY my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf


RUN mkdir -p /var/run/mysqld

RUN chmod 770 /var/run/mysqld/

RUN chown -R mysql:mysql /var/run/mysqld/


COPY script.sh ./

EXPOSE 3306

CMD ["bash", "./script.sh"]
