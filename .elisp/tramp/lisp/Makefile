INSTALL=install -m644
FTPDIR=/home-local/ftp/pub/src/emacs
SLISP=/app/unido-i06/sun4_56/edit/emacs/20.5/share/emacs/site-lisp

all: tramp

tramp: tramp.elc tramp-vc.elc tramp-util.elc

base64.elc: base64.el
	$(EMACS) -batch -f batch-byte-compile base64.el

format-spec.elc: format-spec.el
	$(EMACS) -batch -f batch-byte-compile format-spec.el

tramp.elc: tramp.el base64.elc format-spec.elc
	$(EMACS) -batch --eval "(add-to-list 'load-path \".\")" \
		-f batch-byte-compile tramp.el

tramp-vc.elc: tramp-vc.el tramp.elc
	$(EMACS) -batch --eval "(add-to-list 'load-path \".\")" \
		-f batch-byte-compile tramp-vc.el

tramp-util.elc: tramp-util.el
	$(EMACS) -batch --eval "(add-to-list 'load-path \".\")" \
		-f batch-byte-compile tramp-util.el

install: all
	$(INSTALL) tramp.el $(FTPDIR)

site-lisp: all
	/usr/ucb/$(INSTALL) tramp.el $(SLISP)
	cd $(SLISP) && emacs-20.5 -batch -f batch-byte-compile tramp.el

clean:
	$(RM) *.elc
