cmd_/home/steward/Data/ldd/mips_asm/hello/ldd.o := mipsel-linux-gcc -Wp,-MD,/home/steward/Data/ldd/mips_asm/hello/.ldd.o.d  -nostdinc -isystem /opt/mt7688/lib/gcc/mipsel-buildroot-linux-uclibc/7.4.0/include -I./arch/mips/include -I./arch/mips/include/generated  -I./include -I./arch/mips/include/uapi -I./arch/mips/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -DVMLINUX_LOAD_ADDRESS=0xffffffff80000000 -DLINKER_LOAD_ADDRESS=0x80000000 -DDATAOFFSET=0 -D__ASSEMBLY__ -fno-PIE -mno-check-zero-division -mabi=32 -G 0 -mno-abicalls -fno-pic -pipe -mno-branch-likely -msoft-float -DGAS_HAS_SET_HARDFLOAT -Wa,-msoft-float -ffreestanding -fno-stack-check -march=mips32r2 -mtune=34kc -Wa,--trap -DTOOLCHAIN_SUPPORTS_VIRT -DTOOLCHAIN_SUPPORTS_XPA -DTOOLCHAIN_SUPPORTS_DSP -I./arch/mips/include/asm/mach-ralink -I./arch/mips/include/asm/mach-ralink/mt7620 -I./arch/mips/include/asm/mach-generic -Wa,-gdwarf-2  -DMODULE -mno-long-calls  -c -o /home/steward/Data/ldd/mips_asm/hello/ldd.o /home/steward/Data/ldd/mips_asm/hello/ldd.S

source_/home/steward/Data/ldd/mips_asm/hello/ldd.o := /home/steward/Data/ldd/mips_asm/hello/ldd.S

deps_/home/steward/Data/ldd/mips_asm/hello/ldd.o := \
  include/linux/kconfig.h \
    $(wildcard include/config/cpu/big/endian.h) \
    $(wildcard include/config/booger.h) \
    $(wildcard include/config/foo.h) \

/home/steward/Data/ldd/mips_asm/hello/ldd.o: $(deps_/home/steward/Data/ldd/mips_asm/hello/ldd.o)

$(deps_/home/steward/Data/ldd/mips_asm/hello/ldd.o):
