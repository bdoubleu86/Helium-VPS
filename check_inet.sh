#!/bin/sh

UPTIME_LOG=/root/check_inet_uptimecount.log
UPTIME_TMP=/root/check_inet_uptimecount.tmp
REBOOT_LOG=/root/check_inet_reboots.log

not_inet_action() {
 oldnum=`cut -d ',' -f2 $UPTIME_TMP`
 echo "$(date +%Y-%m-%d-%H-%M-%S): $oldnum this is equal to an uptime of $((oldnum*5)) minutes" >> $REBOOT_LOG
 sleep 70 && touch /etc/banner && reboot
}

reset_uptimecount() {
 cp $UPTIME_LOG $UPTIME_TMP
 echo 0 > $UPTIME_LOG
}

if ping -c5 10.8.0.1; then
 newnum=1
 if test -f "$UPTIME_LOG"; then
  oldnum=`cut -d ',' -f2 $UPTIME_LOG`
  newnum=`expr $oldnum + 1`
 fi
  echo newnum > $UPTIME_LOG
else
 [[ `cat $UPTIME_LOG` == 0 ]] && no_inet_action || reset_uptimecount
fi

exit 0
