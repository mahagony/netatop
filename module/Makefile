# Makefile for linking kernel modules
MYMODULE = netatop
KERNDIR  = /lib/modules/$(shell uname -r)/build
THISDIR  = $(shell pwd)

obj-m   := $(MYMODULE).o

$(MYMODULE).ko: $(MYMODULE).c 
		echo start the make
		make -C $(KERNDIR) M=$(THISDIR) modules

clean:
	rm -f *.o *.ko
	rm -f .netatop*
	rm -f netatop.ko.unsigned netatop.mod.c
	rm -f Module.symvers                
	rm -f modules.order                
	rm -fr .tmp_versions

netatop.o:	../netatop.h	../netatopversion.h
