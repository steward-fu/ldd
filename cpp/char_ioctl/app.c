#include <stdio.h>
#include <stdint.h>
#include <sys/fcntl.h> 
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/ioctl.h>

#define MY_IOCTL _IOWR(0x100, 0, unsigned long)

int main(int argc, char **argv)
{
  int fd=0;

  fd = open("/dev/myfile", O_RDWR);
  ioctl(fd, MY_IOCTL, 0);
  close(fd);
  return 0;
}
