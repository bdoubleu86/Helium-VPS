#!/bin/sh

TMP_FILE=/tmp/inet_up

not_inet_action() {
 sleep 70 && touch /etc/banner && date >> /root/reboot_log && reboot
}

if ping -c5 10.8.0.1; then
 echo 1 > $TMP_FILE
else
 [[ `cat $TMP_FILE` == 0 ]] && no_inet_action || echo 0 > $TMP_FILE
fi

exit 0
