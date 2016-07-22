#!/usr/bin/env bash

envsubst < config.ENV.inc.php > config.inc.php

rm config.ENV.inc.php

exec /docker/bin/gosu root php -S 0.0.0.0:80
