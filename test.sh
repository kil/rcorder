#!/bin/sh
ORIG_RCORDER=/sbin/rcorder
DIRS="/etc/rc.d/* /usr/local/etc/rc.d/*"
SEPS="DAEMON FILESYSTEMS LOGIN NETWORKING SERVERS"
FLAGS="-s noskip"
$ORIG_RCORDER $DIRS > test.orig 2> /dev/null

for SEP in $SEPS; do
	./rcorder $FLAGS -l $SEP $DIRS > test.a 2> /dev/null
	./rcorder $FLAGS -f $SEP $DIRS 2> /dev/null >> test.a

	diff test.orig test.a
	rm test.a
	echo running with seperator $SEP

	./rcorder -d -l $SEP -T ./rc.trampoline -r $FLAGS $DIRS 2> /dev/null \
		| grep _RCORDER_RUN_DEBUG | awk '{print $2}' - > test.b
	./rcorder -d -f $SEP -T ./rc.trampoline -r $FLAGS $DIRS 2> /dev/null \
		| grep _RCORDER_RUN_DEBUG | awk '{print $2}' - > test.c

	DUPS=0
	for x in `cat test.c`; do
		A=$(grep "$x\$" test.b)
		if [ -n "$A" ]; then
			echo DUP $A
			DUPS=1
		fi
	done

	if [ "$DUPS" = "1" ]; then
		exit 1
	fi

	sort test.b test.c > test.d
	sort test.orig > test.e
	diff test.d test.e
	if [ "$?" = "1" ]; then
		echo scripts missing
		exit 1
	fi
done
rm test.b test.c test.d test.e test.orig
