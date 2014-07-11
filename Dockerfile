FROM debian:wheezy

# For nginx
echo "deb http://nginx.org/packages/debian/ wheezy nginx" >> /etc/apt/sources.list
echo "deb-src http://nginx.org/packages/debian/ wheezy nginx" >> /etc/apt/sources.list

# All our build dependencies
RUN apt-get update && apt-get install -y \
    nginx \
		build-essential \
    ca-certificates \
    curl \
		libssl-dev \
		libxslt1-dev \
		openssh-server \
    openssl \
		perl \
		dnsmasq \
		squid3 \
    postgresql \
    procps \
    procps \
    python-psycopg2 \
    python-software-properties \
    software-properties-common \
    python 

RUN echo "host captive captive 127.0.0.1/32 md5" >> /etc/postgresql/9.1/main/pg_hba.conf 
RUN /etc/init.d/postgresql restart

RUN su postgres -c "psql create user captive with password '?fakingthecaptive?'; create database captive; \connect captive; create table pass (id SERIAL, ipv4 varchar(16), ipv6 varchar(40), created timestamp DEFAULT current_timestamp); grant all privileges on database captive to captive; grant all privileges on table pass to captive; grant all privileges on sequence pass_id_seq to captive;"

RUN /etc/init.d/squid restart
RUN sudo /etc/init.d/captive_portal_redirect start



EXPOSE 80
CMD ["nginx"]


# node stuffs
RUN mkdir /root/nvm
WORKDIR /root/nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.10.0/install.sh | bash
RUN nvm install 0.10
RUN nvm use 0.10


