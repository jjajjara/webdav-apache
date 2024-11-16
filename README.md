[https://hub.docker.com/jjajjara/webdav-apache](https://hub.docker.com/r/jjajjara/webdav-apache)

<h2>Usage Instructions</h2>

<h3>Docker Run</h3>
<pre><code>docker run --name webdav \
  --restart unless-stopped \
  -p 8080:80 \
  -e WEBDAV_USERNAME=jjajjara \
  -e WEBDAV_PASSWORD=mypassword \
  -e UID=1000 \
  -e GID=1000 \
  -e TZ=Asia/Seoul \
  -v /data:/var/www/webdav \
  jjajjara/webdav-apache:latest
</code></pre>

<h3>Docker Compose</h3>
<pre><code>services:
  webdav:
    image: jjajjara/webdav-apache:latest 
    container_name: webdav
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      WEBDAV_USERNAME: jjajjara
      WEBDAV_PASSWORD: mypassword 
      UID: 1000
      GID: 1000
      TZ: Asia/Seoul
    volumes:
      - /data:/var/www/webdav
</code></pre>
