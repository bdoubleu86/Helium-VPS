#!/bin/sh

UPTIME_CNT=/root/check_inet_uptimecount.cnt
UPTIME_LOG=/root/check_inet_uptimecount.log
MAX_LINES=10000
TARGET=10.8.0.1

PREFIX="$(date +%Y-%m-%d-%H-%M-%S): "

not_inet_action() {
 sleep 70 && touch /etc/banner && reboot
}

#Rotate the logfile if MAX_LINES is reached
if ((`wc -l < $UPTIME_LOG` > $MAX_LINES)) then
 mv -f $UPTIME_LOG "$(UPTIME_LOG)1"
fi

if ping -c5 $TARGET; then
 newnum=1
 if test -f "$UPTIME_CNT"; then
  oldnum=`cut -d ',' -f2 $UPTIME_CNT`
  newnum=`expr $oldnum + 1`
 fi
 echo newnum > $UPTIME_CNT
 echo "$(PREFIX) Ping to $TARGET successful" >> $UPTIME_LOG
else
 echo "$(PREFIX) Ping to $TARGET failed" >> $UPTIME_LOG
 [[ `cat $UPTIME_CNT` == 0 ]] && no_inet_action || echo 0 > $UPTIME_CNT
fi

exit 0
