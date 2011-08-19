#       $NetBSD: Makefile,v 1.1 1999/11/23 05:28:20 mrg Exp $
# $FreeBSD: stable/8/sbin/rcorder/Makefile 154821 2006-01-25 16:34:33Z dougb $

PROG=   rcorder
SRCS=   ealloc.c hash.c rcorder.c
MAN=	rcorder.8

LDADD=	-lutil
DPADD=	${LIBUTIL}

WARNS?=	6
# XXX hack for make's hash.[ch]
CFLAGS+= -DORDER -I. -DDEBUG=1

SRCS+=	util.h
CLEANFILES+=	util.h

util.h:
	test -f ${.CURDIR}/../../lib/libutil/libutil.h ${.TARGET} && \
	ln -sf ${.CURDIR}/../../lib/libutil/libutil.h ${.TARGET} || \
	ln -sf /usr/include/libutil.h ${.TARGET}

.include <bsd.prog.mk>
