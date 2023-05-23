#!/bin/bash
echo "----------安装依赖---------------"
yum install  libicu-devel gcc gcc-c++ libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel  \
libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel  libevent libevent-devel gd gd-devel \
libmcrypt libmcrypt-devel mcrypt mhash libxslt libxslt-devel readline readline-devel gmp gmp-devel libcurl libcurl-devel\
 openjpeg-devel  libsodium libsodium-devel  openssl-devel -y


useradd www -s /sbin/nologin
mkdir -pv /data/software


ls -l /data/software   |grep "php-8.1"

if [ $? -ne 0 ]
then
    echo "请手动把PHP包放在/data/software目录"
    exit
fi

cd /data/software
tar -xf php-8.1.4.tar.gz
cd php-8.1.4
cp /usr/local/lib/libzip/include/zipconf.h /usr/local/include/zipconf.h

echo "--------------开始编译---------------------"
./configure --prefix=/usr/local/php   '--enable-static=yes' '--enable-shared=no' '--disable-shared' '--disable-option-checking' '--enable-opcache=static'\
 '--with-config-file-path=/usr/local/php/etc' '--with-config-file-scan-dir=/usr/local/php/conf.d' '--disable-phpdbg' '--disable-ipv6' '--with-libxml-dir=/usr/local/php' \
'--enable-soap' '--with-pcre-dir=/usr/local/php' '--with-pcre-regex' '--enable-zip' '--with-zlib-dir=/usr/local/php' '--with-libzip=/usr/local/libzip' '--enable-calendar' \
'--enable-exif' '--enable-sockets' '--enable-mysqlnd' '--enable-bcmath' '--with-openssl'  '--with-curl' '--with-iconv' '--with-mysqli=mysqlnd' '--enable-mbstring' \
'--with-pdo-mysql=mysqlnd' '--with-pdo-sqlite' '--enable-pcntl' '--enable-sysvmsg' '--enable-sysvsem' '--enable-sysvshm' '--without-pear' '--enable-intl' '--with-readline' \
'--enable-igbinary'  '--with-sodium' '--enable-memcached'  '--enable-memcached-igbinary' '--enable-memcached-json' '--enable-redis' '--enable-redis-igbinary'\
 '--enable-async-redis' '--localedir=/usr/share/locale' '--localstatedir=/var' '--sharedstatedir=/var/lib' '--with-default-fonts=/usr/share/fonts/' '--with-xmldir=/usr/share/xml/fontconfig' \
'--with-gd' '--with-xpm-dir=no' '--with-webp-dir=no' '--with-jpeg-dir=/usr/local/php' '--with-freetype-dir=/usr/local/php' '--with-png-dir=/usr/local/php' '--enable-mongodb' \
'--with-libbson' '--with-libmongoc' '--with-mongodb-sasl=/usr/local/php' '--enable-tideways-xhprof' '--enable-swoole-static' '--with-swoole' '--enable-cli' '--disable-cgi' \
'PKG_CONFIG_PATH=/usr/local/php/lib/pkgconfig/' '--with-fpm-user=www' '--with-fpm-group=www' '--enable-fpm'

if [ $? -eq 0 ]
then
    make && make install
else
    exit
fi

 cp /data/software/php-8.1.4/php.ini-production  /usr/local/php/etc/php.ini

cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf

cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf

chown www.www /usr/local/php -R

cat > /usr/lib/systemd/system/php-fpm.service << EOF
[Unit]
Description=PHP FastCGI Service
After=syslog.target network.target


[Service]
# start main service
ExecStart=/usr/local/php/sbin/php-fpm --nodaemonize --fpm-config /usr/local/php/etc/php-fpm.conf

# restart main service
ExecReload=/bin/kill -USR2 $MAINPID

# stop main service
ExecStop=/bin/kill -SIGINT $MAINPID


[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload

systemctl enable php-fpm


