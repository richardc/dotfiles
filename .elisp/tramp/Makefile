# Makefile to build TRAMP, such as it is...
# requires GNU make and GNU tar.
# This should be improved.

# If we seem to be in an XEmacs package hierarchy, build packages.
# Otherwise, use the upstream rules.
# #### I don't think we need to strip the result of $(wildcard ...)
ifeq (,$(wildcard ../../XEmacs.rules))

# This version number we use for this package.
VERSION=2.0.25

# This is not an XEmacs package.

# N.B.  Configuration of utilities for XEmacs packages is done in
# ../../Local.rules.  These have no effect on XEmacs's package build
# process (and thus live inside the conditional).
EMACS	 = emacs
MAKEINFO = makeinfo
DIRS	 = lisp texi

.PHONY: MANIFEST info

all:
	for a in ${DIRS}; do						\
	    $(MAKE) -C $$a "EMACS=$(EMACS)" "MAKEINFO=$(MAKEINFO)"      \
		"VERSION=$(VERSION)" all;                 		\
	done

info:
	$(MAKE) -C texi all

prepversion:
	for a in ${DIRS}; do						\
	    $(MAKE) -C $$a "EMACS=$(EMACS)" "MAKEINFO=$(MAKEINFO)"	\
	        "VERSION=$(VERSION)" prepversion;			\
	done

clean:
	for a in ${DIRS}; do						\
	    $(MAKE) -C $$a "EMACS=$(EMACS)" "MAKEINFO=$(MAKEINFO)" clean; \
	done

realclean:
	rm -f MANIFEST tramp.tar.gz
	rm -rf info

tag: prepversion
	cvs tag V-`echo $(VERSION) | tr . -`

MANIFEST:
	find . \( -name CVS -prune \)				\
		-o \( -name tmp -prune \)			\
		-o -type f \! -name "*~"			\
		-a \! -name "*.elc" -a \! -name "*.aux"		\
		-a \! -name "*.cp" -a \! -name "*.fn"		\
		-a \! -name "*.vr" -a \! -name "*.tp"		\
		-a \! -name "*.ky" -a \! -name "*.pg"		\
		-a \! -name "*.tmp" -a \! -name "*.log"		\
		-a \! -name "*.toc" -a \! -name "*,v"		\
		-a \! -name "*.tar.gz"				\
		-a \! -name ".#*"				\
		-print > MANIFEST

tar: prepversion MANIFEST
	mkdir tramp-$(VERSION)
	tar cpfT - MANIFEST | ( cd tramp-$(VERSION) ; tar xpf - )
	tar cvpfz tramp-$(VERSION).tar.gz tramp-$(VERSION)
	rm -rf tramp-$(VERSION)
	chmod a+r tramp-$(VERSION).tar.gz

xemacs:
	cp lisp/ChangeLog lisp/tramp*.el ../../kai/xemacs/tramp/lisp
	cp texi/ChangeLog texi/tramp*.texi ../../kai/xemacs/tramp/texi
	cp test/*.el ../../kai/xemacs/tramp/test

dist: tar tag
	if [ -d /home-local/ftp/pub/src/emacs ]; then	\
		install -m644 tramp-$(VERSION).tar.gz	\
			/home-local/ftp/pub/src/emacs;	\
	fi

install-html:
	cd texi ; $(MAKE) install-html

savannah: dist
	scp tramp-$(VERSION).tar.gz kai@freesoftware.fsf.org:/upload/tramp
	cd texi ; $(MAKE) savannah

cvs-update:
	cvs update -dP

else

# This is an XEmacs package.
include Makefile.XEmacs
endif
