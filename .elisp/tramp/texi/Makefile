# Makefile, does build info from texi
# Requires makeinfo, assumes it to be in the path...
# Only works with TeXinfo 4.x.  (It may be sufficient to replace
# @command with @code to make it work with TeXinfo 3.x.)

INSTALL=install -m644
SINFO=/app/unido-i06/sun4_56/edit/emacs/20.5/share/emacs/site-info
EMACS-ID=$(if $(shell echo $(EMACS) | grep -i xemacs),xemacs,emacs)

all: prepversion prepemacs tramp dvi tramp.html

clean:
	-rm -f *.aux *.cp *.cps *.fn *.ky *.log *.pg *.tmp *.toc *.tp *.vr
	-rm -f *.info *.html *~

prepversion:
	(echo "/@macro trampver";		\
	 echo "+";				\
	 echo "c";				\
	 echo "$(VERSION)";			\
	 echo ".";				\
	 echo "w";				\
	 echo "q") | ed tramp.texi

prepemacs:
	sed "s/^@set x\{0,1\}emacs$$/@set $(EMACS-ID)/g" tramp.texi >$$$$; \
	mv $$$$ tramp.texi

tramp: tramp.texi
	test -d ../info || mkdir ../info
	$(MAKEINFO) --footnote-style=end --no-split -o ../info/tramp tramp.texi
#	install-info --info-dir=. tramp.info

dvi: tramp.dvi

tramp.dvi: tramp.texi
	texi2dvi tramp.texi

tramp.html: tramp.texi
	$(MAKEINFO) --html --no-split -o tramp.html tramp.texi

site-info: tramp
	/usr/ucb/$(INSTALL) tramp $(SINFO)

install-html: tramp.html tramp_ja.html
	$(INSTALL) tramp.html tramp_ja.html $$HOME/public-html/emacs

# For Japanese manual
tramp_ja.info: tramp_ja.texi
	test -d ../info || mkdir ../info
	$(MAKEINFO) --footnote-style=end --no-split tramp_ja.texi
#	install-info --info=dir=. tramp_ja.info

tramp_ja.html: tramp_ja.texi
	$(MAKEINFO) --html --no-split -o tramp_ja.html tramp_ja.texi

savannah: tramp.html tramp_ja.html
	cp tramp.html ../../tramp-web/non-gnu/tramp/index.html
	cp tramp_ja.html ../../tramp-web/non-gnu/tramp
	@echo ""
	@echo "Now use cvs checkin in ../../tramp-web/non-gnu/tramp"
	@echo ""

