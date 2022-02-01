#!/bin/sh

UPTIME_LOG=/root/check_inet_uptimecount.log
REBOOT_LOG=/root/check_inet_reboots.log

not_inet_action() {
 sleep 70 && touch /etc/banner && date >> $REBOOT_LOG && reboot
}

if ping -c5 10.8.0.1; then
 if test -f "$UPTIME_LOG"; then
  oldnum=`cut -d ',' -f2 $UPTIME_LOG`
  newnum=`expr $oldnum + 1`
  sed -i "s/$oldnum\$/$newnum/g" $UPTIME_LOG
 else
  echo 1 > $UPTIME_LOG
 fi
else
 [[ `cat $UPTIME_LOG` == 0 ]] && no_inet_action || echo 0 > $UPTIME_LOG
fi

exit 0
