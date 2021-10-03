# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

# dwm version
VERSION = 6.2

# paths
PREFIX = /usr/local
MAN_PREFIX = ${PREFIX}/share/man

X11_INC = /usr/X11R6/include
X11_LIB = /usr/X11R6/lib

# Xinerama, comment if you don't want it
XINERAMA_LIBS  = -lXinerama
XINERAMA_FLAGS = -DXINERAMA

# freetype
FREE_TYPE_LIBS = -lfontconfig -lXft
FREE_TYPE_INC = /usr/include/freetype2
# OpenBSD (uncomment)
#FREE_TYPE_INC = ${X11_INC}/freetype2

# includes and libs
INCS = -I${X11_INC} -I${FREE_TYPE_INC}
LIBS = -L${X11_LIB} -lX11 ${XINERAMA_LIBS} ${FREE_TYPE_LIBS}

CC = clang
CPP_FLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_POSIX_C_SOURCE=200809L -DVERSION=\"${VERSION}\" ${XINERAMA_FLAGS}
#CFLAGS   = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPP_FLAGS}
C_FLAGS   = -std=c99 -pedantic -Wall -O3 -Wno-deprecated-declarations -Os ${INCS} ${CPP_FLAGS}
LD_FLAGS  = ${LIBS}

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: options dwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${C_FLAGS}"
	@echo "LDFLAGS  = ${L_DFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${C_FLAGS} $<

${OBJ}: config.h

config.h:
	cp config.def.h $@

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LD_FLAGS}

clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h\
		dwm.1 drw.h util.h ${SRC} transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MAN_PREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MAN_PREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MAN_PREFIX}/man1/dwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MAN_PREFIX}/man1/dwm.1

.PHONY: all options clean dist install uninstall

