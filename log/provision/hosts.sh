#!/usr/bin/env bash

if [ -f /tmp/hosts ] && ! grep -c '#LogNodes start' /etc/hosts
then {
	cat /tmp/hosts >> /etc/hosts 
}
fi 
