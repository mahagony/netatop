all:
		./mkversion
		cd module; make
		cd daemon; make

install:	module/netatop.ko daemon/netatopd
		install -d /lib/modules/`uname -r`/extra
		install -m 0644 module/netatop.ko -t /lib/modules/`uname -r`/extra
		depmod
		install daemon/netatopd -t /usr/sbin
		# install -T -m 0755 netatop.init /etc/init.d/netatop
		install -m 0644 netatop.service -t /lib/systemd/system
		install man/netatop.4 -t /usr/share/man/man4
		install man/netatopd.8 -t /usr/share/man/man8

clean:
		cd module; make clean
		cd daemon; make clean

dkms_install:
		install -d /usr/src/netatop-3.0
		install dkms/dkms.conf -t /usr/src/netatop-3.0
		install dkms/Makefile -t /usr/src/netatop-3.0
		install netatop.h -t /usr/src/netatop-3.0
		install netatopversion.h -t /usr/src/netatop-3.0
		install module/netatop.c -t /usr/src/netatop-3.0
		patch /usr/src/netatop-3.0/netatop.c dkms/netatop.c.patch
		dkms add -m netatop -v 3.0
		dkms autoinstall --verbose

dkms_uninstall:
		dkms remove netatop/3.0 --all
