# Step 1: Ubuntu 기반 이미지 사용
FROM ubuntu:22.04

# Step 2: 필요한 패키지 설치
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    apache2 \
    apache2-utils \
    gosu \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# Step 3: WebDAV 모듈 활성화
RUN a2enmod dav dav_fs && \
    mkdir -p /var/lib/dav && \
    chown www-data:www-data /var/lib/dav

# Step 4: WebDAV 설정 파일 복사
COPY webdav.conf /etc/apache2/sites-available/000-default.conf

# Step 5: WebDAV 데이터 디렉터리 준비
RUN mkdir -p /var/www/webdav && \
    chown -R www-data:www-data /var/www/webdav && \
    chmod -R 775 /var/www/webdav

# Step 6: Entrypoint 스크립트 복사 및 실행 권한 부여
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Step 7: 볼륨 지정
VOLUME /var/www/webdav

# Step 8: Entrypoint 설정 및 실행
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
