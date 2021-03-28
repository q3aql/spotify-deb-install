##################################
# spotify-deb-install (Makefile) #
##################################

PREFIX=/usr

install:
	cp -rfv src/spotify-deb-install $(PREFIX)/bin/spotify-deb-install
	chmod +x $(PREFIX)/bin/spotify-deb-install
	
uninstall:
	rm $(PREFIX)/bin/spotify-deb-install

