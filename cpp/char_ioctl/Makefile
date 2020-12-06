export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
KERNEL=$(HOME)/Downloads/kernel

obj-m += main.o
all:
	$(CROSS_COMPILE)gcc app.c -o app -static
	make -C $(KERNEL) M=$(PWD) modules

clean:
	make -C $(KERNEL) M=$(PWD) clean
