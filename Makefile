PREFIX?=/usr/local

install:
	@install -Dm755 dot.mk ${PREFIX}/bin/dot.mk

uninstall:
	@rm ${PREFIX}/bin/dot.mk
