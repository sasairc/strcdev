#
#    Makefile for strcdev
#

obj-m	= strcdev.o
TARGET	= strcdev.ko
PREFIX	:= /lib/modules/$(shell uname -r)/kernel/drivers/block
KERNDIR	:= /lib/modules/$(shell uname -r)/build
BUILDIR	:= $(shell pwd)
MAKE	:= make
CC	:= cc
RM	:= rm

all: $(TARGET)

$(TARGET): $(TARGET:.ko=.c)
	$(MAKE) -C $(KERNDIR) SUBDIRS=$(BUILDIR) modules

install: install-module mknod

install-module: $(TARGET)
	cp strcdev.ko $(PREFIX)/strcdev.ko

mknod:
	mknod /dev/strcdev c 250 0
	chmod 0666 /dev/strcdev

uninstall: uninstall-module rmnod

uninstall-module:
	-$(RM) -f $(PREFIX)/strcdev.ko

rmnod:
	-$(RM) -f /dev/strcdev

clean:
	-$(RM) -f *.o *.ko *.mod.[co] *.symvers *.order

.PHONY:	all install install-module mknod uninstall uninstall-module rmnod clean
