export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
KERNEL=$(HOME)/kernel

obj-m += main.o
all:
	make -C $(KERNEL) M=$(PWD) modules

clean:
	make -C $(KERNEL) M=$(PWD) clean
