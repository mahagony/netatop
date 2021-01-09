all:
		cd module; make
		cd daemon; make

install:	daemon/netatopd
		install daemon/netatopd -t /usr/sbin
		install -m 0644 netatop.service -t /lib/systemd/system
		install man/netatop.4 -t /usr/share/man/man4
		install man/netatopd.8 -t /usr/share/man/man8

clean:
		cd module; make clean
		cd daemon; make clean

dkms_install:
		install -d /usr/src/netatop-3.1
		install dkms/dkms.conf -t /usr/src/netatop-3.1
		install dkms/Makefile -t /usr/src/netatop-3.1
		install netatop.h -t /usr/src/netatop-3.1
		install netatopversion.h -t /usr/src/netatop-3.1
		install module/netatop.c -t /usr/src/netatop-3.1
		patch /usr/src/netatop-3.1/netatop.c dkms/netatop.c.patch
		dkms add -m netatop -v 3.1
		dkms build -m netatop -v 3.1
		dkms install -m netatop -v 3.1 --force

dkms_uninstall:
		dkms uninstall -m netatop -v 3.1
		dkms remove -m netatop -v 3.1 --all
