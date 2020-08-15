#!/bin/bash

set -e

if [ "$(id -u)" = '0' ] && [[ $(sysctl -w net.core.somaxconn=8192) ]]; then
	sysctl -w vm.overcommit_memory=1
	echo never|tee /sys/kernel/mm/transparent_hugepage/{defrag,enabled}
fi

DEFAULT_CONF=${DEFAULT_CONF:-enable}
REDIS_PASS=${REDIS_PASS:-$(date +"%s%N"| sha256sum | base64 | head -c 16)}

if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- redis-server "$@"
fi

if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	[ -d ${DATA_DIR} ] && chown -R redis.redis ${DATA_DIR}
	[ -f "$2" ] && chown redis.redis $2
	exec su-exec redis "$0" "$@"
fi

if [ "$1" = 'redis-server' ]; then
	# Disable Redis protected mode [1] as it is unnecessary in context
	# of Docker. Ports are not automatically exposed when running inside
	# Docker, but rather explicitely by specifying -p / -P.
	# [1] https://github.com/antirez/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
	doProtectedMode=1
	configFile=
	if [ -f "$2" ]; then
		configFile="$2"
		if grep -q '^protected-mode' "$configFile"; then
			doProtectedMode=
		fi
		if [[ ! ${DEFAULT_CONF} =~ ^[dD][iI][sS][aA][bB][lL][eE]$ ]]; then
			[[ -z $(grep '^requirepass' "$configFile") ]] && echo "requirepass ${REDIS_PASS}" >> $configFile
			echo -e "\033[45;37;1mRedis Server Auth Password : $(awk '/^requirepass/{print $NF}' $configFile)\033[39;49;0m"
		fi
	fi
	if [ "$doProtectedMode" ]; then
		shift # "redis-server"
		if [ "$configFile" ]; then
			shift
		fi
		set -- --protected-mode no "$@"
		if [ "$configFile" ]; then
			set -- "$configFile" "$@"
		fi
		set -- redis-server "$@" 
	fi
fi

exec "$@"
