#!/usr/bin/env bash

apt-get install curl -y

curl -sS https://getcomposer.org/installer | php


mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer