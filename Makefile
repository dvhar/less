# Makefile for less.

#### Start of system configuration section. ####

srcdir = .


CC = gcc
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644

CFLAGS = -g -O2
CFLAGS_COMPILE_ONLY = -c
LDFLAGS = 
CPPFLAGS = 
EXEEXT = 
O=o

LIBS =  -ltinfo

prefix = /usr/local
exec_prefix = ${prefix}

# Where the installed binary goes.
bindir = ${exec_prefix}/bin
binprefix = 

sysconfdir = ${prefix}/etc
datarootdir = ${prefix}/share

mandir = ${datarootdir}/man
manext = 1
manprefix = 
DESTDIR =

#### End of system configuration section. ####

SHELL = /bin/sh

# This rule allows us to supply the necessary -D options
# in addition to whatever the user asks for.
.c.o:
	${CC} -I. ${CFLAGS_COMPILE_ONLY} -DBINDIR=\"${bindir}\" -DSYSDIR=\"${sysconfdir}\" ${CPPFLAGS} ${CFLAGS} $<

OBJ = \
	main.${O} screen.${O} brac.${O} ch.${O} charset.${O} cmdbuf.${O} \
	command.${O} cvt.${O} decode.${O} edit.${O} filename.${O} forwback.${O} \
	help.${O} ifile.${O} input.${O} jump.${O} line.${O} linenum.${O} \
	lsystem.${O} mark.${O} optfunc.${O} option.${O} opttbl.${O} os.${O} \
	output.${O} pattern.${O} position.${O} prompt.${O} search.${O} signal.${O} \
	tags.${O} ttyin.${O} version.${O}  

all: less$(EXEEXT) lesskey$(EXEEXT) lessecho$(EXEEXT)

less$(EXEEXT): ${OBJ}
	${CC} ${LDFLAGS} -o $@ ${OBJ} ${LIBS}

lesskey$(EXEEXT): lesskey.${O} version.${O}
	${CC} ${LDFLAGS} -o $@ lesskey.${O} version.${O}

lessecho$(EXEEXT): lessecho.${O} version.${O}
	${CC} ${LDFLAGS} -o $@ lessecho.${O} version.${O}

charset.${O}: compose.uni ubin.uni wide.uni

${OBJ}: ${srcdir}/less.h ${srcdir}/funcs.h defines.h 

install: all ${srcdir}/less.nro ${srcdir}/lesskey.nro ${srcdir}/lessecho.nro installdirs
	${INSTALL_PROGRAM} less$(EXEEXT) ${DESTDIR}${bindir}/${binprefix}less$(EXEEXT)
	${INSTALL_PROGRAM} lesskey$(EXEEXT) ${DESTDIR}${bindir}/${binprefix}lesskey$(EXEEXT)
	${INSTALL_PROGRAM} lessecho$(EXEEXT) ${DESTDIR}${bindir}/${binprefix}lessecho$(EXEEXT)
	${INSTALL_DATA} ${srcdir}/less.nro ${DESTDIR}${mandir}/man${manext}/${manprefix}less.${manext}
	${INSTALL_DATA} ${srcdir}/lesskey.nro ${DESTDIR}${mandir}/man${manext}/${manprefix}lesskey.${manext}
	${INSTALL_DATA} ${srcdir}/lessecho.nro ${DESTDIR}${mandir}/man${manext}/${manprefix}lessecho.${manext}

install-strip:
	${MAKE} INSTALL_PROGRAM='${INSTALL_PROGRAM} -s' install

installdirs: mkinstalldirs
	${srcdir}/mkinstalldirs ${DESTDIR}${bindir} ${DESTDIR}${mandir}/man${manext}

uninstall:
	rm -f ${DESTDIR}${bindir}/${binprefix}less$(EXEEXT)
	rm -f ${DESTDIR}${bindir}/${binprefix}lesskey$(EXEEXT)
	rm -f ${DESTDIR}${bindir}/${binprefix}lessecho$(EXEEXT)
	rm -f ${DESTDIR}${mandir}/man${manext}/${manprefix}less.${manext}
	rm -f ${DESTDIR}${mandir}/man${manext}/${manprefix}lesskey.${manext}
	rm -f ${DESTDIR}${mandir}/man${manext}/${manprefix}lessecho.${manext}

info:
install-info:
dvi:
check:
installcheck:

TAGS:
	cd ${srcdir} && etags *.c *.h

# config.status might not change defines.h
# Don't rerun config.status if we just configured (so there's no stamp-h).
defines.h: stamp-h
stamp-h: defines.h.in config.status
	test ! -f stamp-h || CONFIG_FILES= CONFIG_HEADERS=defines.h ./config.status
	touch stamp-h
Makefile: ${srcdir}/Makefile.in config.status
	CONFIG_FILES=Makefile CONFIG_HEADERS= ./config.status
config.status: ${srcdir}/configure
	./config.status --recheck

${srcdir}/configure: ${srcdir}/configure.ac
	cd ${srcdir}; autoheader; autoconf

clean:
	rm -f *.${O} core less$(EXEEXT) lesskey$(EXEEXT) lessecho$(EXEEXT)

mostlyclean: clean

distclean: clean
	rm -f Makefile config.status config.log config.cache defines.h stamp-h

realclean: distclean
	rm -f TAGS

