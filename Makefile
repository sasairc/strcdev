obj-m	:= strcdev.o
clean-files := *.o *.ko *.mod.[co] *.symvers *.order
clean-files-all	:=	strcdev.c convert.txt *.tmp .*.cmd

TARGET	:= strcdev.ko
PREFIX	:= /lib/modules/$(shell uname -r)/kernel/drivers/block
KERNDIR	:= /lib/modules/$(shell uname -r)/build
BUILDIR	:= $(shell pwd)
EXTRA_CFLAGS +=
MAKE	:= make
CC		:= cc
RM		:= rm

all: $(TARGET)

strcdev.ko:	strcdev.c
	$(MAKE) -C $(KERNDIR) SUBDIRS=$(BUILDIR) modules

install:
	cp -v strcdev.ko $(PREFIX)/strcdev.ko
	mknod /dev/strcdev c 250 0
	chmod 0666 /dev/strcdev

mknod:
	mknod /dev/strcdev c 250 0
	chmod 0666 /dev/strcdev

rmnod:
	-$(RM) -f /dev/strcdev

uninstall:
	-$(RM) -f $(PREFIX)/strcdev.ko
	-$(RM) -f /dev/strcdev

clean:
	-$(RM) -fv $(obj-m) $(clean-files)

clean_all:
	-$(RM) -fv $(obj-m) $(clean-files) $(clean-files-all)
