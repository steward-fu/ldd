export ARCH=mips
export CROSS_COMPILE=mipsel-linux-
export AS=${CROSS_COMPILE}as
KERNEL=$(HOME)/Downloads/kernel

obj-m += main.o
main-objs:= ldd.o
all:
	$(AS) -o ldd.o ldd.S
	make -C $(KERNEL) M=$(PWD) modules

clean:
	make -C $(KERNEL) M=$(PWD) clean
