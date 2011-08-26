#!/bin/sh
ORIG_RCORDER=/sbin/rcorder
DIRS="/etc/rc.d/* /usr/local/etc/rc.d/*"
SEPS="DAEMON FILESYSTEMS LOGIN NETWORKING SERVERS"
FLAGS="-s noskip"
$ORIG_RCORDER $DIRS > test.orig 2> /dev/null

for SEP in $SEPS; do
	./rcorder $FLAGS -l $SEP $DIRS > test.a 2> /dev/null
	./rcorder $FLAGS -f $SEP $DIRS 2> /dev/null \
		| sed -n -e '2,$p' >> test.a

	diff test.orig test.a
	rm test.a


	./rcorder -d -l $SEP -T ./rc.trampoline -r $FLAGS $DIRS 2> /dev/null \
		| grep _RCORDER_RUN_DEBUG | awk '{print $2}' - > test.b
	./rcorder -d -f $SEP -T ./rc.trampoline -r $FLAGS $DIRS 2> /dev/null \
		| grep _RCORDER_RUN_DEBUG | awk '{print $2}' - > test.c

	for x in `cat test.c`; do
		A=$(grep "$x\$" test.b)
		if [ -n "$A" ]; then
			echo DUP $A
			exit 1
		fi
	done

	sort test.b test.c > test.d
	sort test.orig > test.e
	diff test.d test.e
done
rm test.b test.c test.d test.e test.orig
