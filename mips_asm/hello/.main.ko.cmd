cmd_/home/steward/Data/ldd/mips_asm/hello/main.ko := mipsel-linux-ld -r  -m elf32ltsmip  --build-id  -T ./scripts/module-common.lds -o /home/steward/Data/ldd/mips_asm/hello/main.ko /home/steward/Data/ldd/mips_asm/hello/main.o /home/steward/Data/ldd/mips_asm/hello/main.mod.o;  make -f ./arch/mips/Makefile.postlink /home/steward/Data/ldd/mips_asm/hello/main.ko