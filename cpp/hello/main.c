#include <linux/init.h>
#include <linux/device.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Steward Fu");
MODULE_DESCRIPTION("Linux Driver");
 
int ldd_init(void)
{
  printk("hello, world!\n");
  return 0;
}
 
void ldd_exit(void)
{
  printk("unload it\n");
}
 
module_init(ldd_init);
module_exit(ldd_exit);

