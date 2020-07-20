FROM ubuntu:16.04

ENV HOME /root

# No ncurses prompts
ENV DEBIAN_FRONTEND noninteractive

# Update packages and install tools 
RUN apt-get update -y --fix-missing
RUN apt-get install -y --no-install-recommends \
    netcat-traditional \
    openssl \
    libpcre3 \
    dnsmasq \
    procps \
    curl

RUN apt-get install -y ca-certificates apt-transport-https

# add KONG PPA
RUN curl -L https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add -
RUN echo "deb https://kong.bintray.com/kong-community-edition-deb xenial main" >> /etc/apt/sources.list.d/kong.list

RUN apt-get update 
RUN apt-get install -y --no-install-recommends kong=0.10.4

COPY nginx_kong.lua /usr/local/share/lua/5.1/kong/templates/nginx_kong.lua
COPY kong.conf /etc/kong/kong.conf

# Kong 0.9.6 causes problems if /etc/kong/kong.conf exists and there is
# more than one nginx instance running
# 2019-02-19: this doesn't appear to be a problem with 0.10.4
# custom-kong.conf renamed back to kong.conf
RUN printf "* soft nofile 4096\n* hard nofile 4096\nroot soft nofile 4096\nroot hard nofile 4096\n" >> /etc/security/limits.conf

# make sure the logs dir exists and is writable
#RUN mkdir -p /var/log/kong && chown www-data:root /var/log/kong && chmod 755 /var/log/kong

# make 'kong' executable by the 'www-data' user
#RUN chown -R www-data:root /usr/local/kong && chown www-data:root /usr/local/bin/kong && chmod -R g=u /usr/local/kong

COPY healthcheck.sh .
HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD ./healthcheck.sh

#USER www-data

EXPOSE 8000

CMD ["/usr/local/bin/kong", "start"]
