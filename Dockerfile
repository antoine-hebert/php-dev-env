FROM alpine:3.2
Maintainer Antoine Hebert <antoine.hebert@gmail.com>

# Add commonly used packages
RUN apk add --update bind-tools && \
    rm -rf /var/cache/apk/*

# Add s6-overlay
ENV S6_OVERLAY_VERSION v1.16.0.1

RUN apk add --update curl && \
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    | tar xvfz - -C / && \
    apk del curl && \
    rm -rf /var/cache/apk/*

# Install apache
RUN apk add --update apache2=2.4.16-r0 apache2-utils=2.4.16-r0 php-apache2 && \
    rm -rf /var/cache/apk/*

# Install phpMyAdmin
RUN apk add --update phpmyadmin && \
    rm -rf /var/cache/apk/* && \
	chown -R apache:apache /etc/phpmyadmin && \
	sed -i "s:\['host'\] = '[^']*';:\['host'\] = 'db';:g" /etc/phpmyadmin/config.inc.php

# Add the files
ADD root /

# Expose the ports for apache
EXPOSE 80 443

ENTRYPOINT ["/init"]
CMD []