# Makefile to build TRAMP, such as it is...
# requires GNU make and GNU tar.
# This should be improved.

DIRS	= lisp texi

EMACS	= emacs
MAKEINFO	= makeinfo

.PHONY: MANIFEST

all:
	for a in ${DIRS}; do						\
	    $(MAKE) -C $$a "EMACS=$(EMACS)" "MAKEINFO=$(MAKEINFO)" all;	\
	done

clean:
	rm -f MANIFEST tramp.tar.gz
	for a in ${DIRS}; do						\
	    $(MAKE) -C $$a "EMACS=$(EMACS)" "MAKEINFO=$(MAKEINFO)" clean; \
	done

MANIFEST:
	cd .. ;							\
	find tramp \( -name CVS -prune \)			\
		-o \( -name tmp -prune \)			\
		-o -type f \! -name "*~"			\
		-a \! -name "*.elc" -a \! -name "*.aux"		\
		-a \! -name "*.cp" -a \! -name "*.fn"		\
		-a \! -name "*.vr" -a \! -name "*.tp"		\
		-a \! -name "*.ky" -a \! -name "*.pg"		\
		-a \! -name "*.tmp" -a \! -name "*.log"		\
		-a \! -name "*.toc" -a \! -name "*,v"		\
		-a \! -name "*.tar.gz"				\
		-print > MANIFEST

tar: MANIFEST
	cd .. ; tar cvpfzT tramp/tramp.tar.gz MANIFEST

dist: tar
	install -m644 tramp.tar.gz /home-local/ftp/pub/src/emacs
#	install -m644 lisp/tramp.el /home-local/ftp/pub/src/emacs

install-html:
	cd texi ; $(MAKE) install-html

sourceforge: dist
	cd texi ; $(MAKE) sourceforge
	scp tramp.tar.gz kaig@tramp.sourceforge.net:/home/groups/t/tr/tramp/htdocs/download
