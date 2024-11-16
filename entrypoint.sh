#!/bin/sh -eux

# Set timezone
if [ -n "${TZ:-}" ]; then
    echo "Setting timezone to ${TZ}"
    echo "${TZ}" > /etc/timezone
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
else
    echo "No TZ variable set. Defaulting to UTC."
    echo "UTC" > /etc/timezone
    ln -snf /usr/share/zoneinfo/UTC /etc/localtime
fi

# Configure WebDAV authentication
if [ -n "${WEBDAV_USERNAME:-}" ] && [ -n "${WEBDAV_PASSWORD:-}" ]; then
    echo "Creating htpasswd file for WebDAV"
    htpasswd -cb /etc/apache2/webdav.passwd "$WEBDAV_USERNAME" "$WEBDAV_PASSWORD"
else
    echo "No WEBDAV_USERNAME or WEBDAV_PASSWORD set. Disabling authentication."
    sed -i 's/AuthType Basic/#AuthType Basic/g' /etc/apache2/sites-available/000-default.conf
    sed -i 's/AuthName "WebDAV Restricted Area"/#AuthName "WebDAV Restricted Area"/g' /etc/apache2/sites-available/000-default.conf
    sed -i 's/AuthUserFile/#AuthUserFile/g' /etc/apache2/sites-available/000-default.conf
    sed -i 's/Require valid-user/Require all granted/g' /etc/apache2/sites-available/000-default.conf
fi

# Ensure proper permissions for WebDAV directory
if [ -n "${UID:-}" ] && [ -n "${GID:-}" ]; then
    echo "Setting UID:GID for /var/www/webdav to ${UID}:${GID}"
    chown -R "${UID}:${GID}" /var/www/webdav
fi

# Start Apache in foreground
exec apache2ctl -D FOREGROUND
