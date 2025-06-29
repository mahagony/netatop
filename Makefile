KERNDIR  = /lib/modules/$(shell uname -r)/build
THISDIR  = $(shell pwd)
CURVERS  = $(shell grep 'PACKAGE_VERSION' dkms.conf | sed -e 's/^.*=//' -e 's/"//g')

obj-m   := netatop.o

all:			version netatop.ko netatopd

version:		dkms.conf
			./mkversion

netatop.ko: 		netatop.c
			$(MAKE) -C $(KERNDIR) M=$(THISDIR) modules

netatopd:		netatopd.o Makefile
			$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) netatopd.o -o netatopd -lz

netatop.ko:		netatop.h   netatopversion.h
netatopd.o:		netatop.h   netatopversion.h   netatopd.h


install:		netatop.ko netatopd
			cd /usr/src; dkms add -m netatop -v $(CURVERS)
			dkms build   -m netatop -v $(CURVERS)
			dkms install -m netatop -v $(CURVERS)
			#
			install netatopd -t /usr/sbin
			install -m 0644 netatop.service -t /lib/systemd/system
			install man/netatop.4 -t /usr/share/man/man4
			install man/netatopd.8 -t /usr/share/man/man8

clean:
			rm -f *.o *.ko
			rm -f .netatop*
			rm -f netatop.ko.unsigned netatop.mod.c
			rm -f netatop.mod
			rm -f Module.symvers                
			rm -f modules.order                
			rm -fr .tmp_versions
			rm -f .Module.symvers.cmd
			rm -f .modules.order.cmd
			rm -f netatop.mod
			rm -f netatopd
