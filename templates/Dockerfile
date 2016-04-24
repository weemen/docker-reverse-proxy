FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y --force-yes apache2 curl vim

RUN echo "<h1>Running from Docker on CoreOS</h1>" > /var/www/html/index.html

