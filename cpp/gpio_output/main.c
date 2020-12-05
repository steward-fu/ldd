#include <linux/init.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/delay.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/gpio.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Steward Fu");
MODULE_DESCRIPTION("Linux Driver");
 
#define USR3_LED ((32 * 1) + 24)

int ldd_init(void)
{
  int c=0;

  gpio_request(USR3_LED, "USR3");
  gpio_direction_output(USR3_LED, 1);
  for(c=0; c<3; c++){
    gpio_set_value(USR3_LED, 0);
    msleep(1000);
    gpio_set_value(USR3_LED, 1);
    msleep(1000);
  }
  gpio_free(USR3_LED);
  return 0;
}
 
void ldd_exit(void)
{
}
 
module_init(ldd_init);
module_exit(ldd_exit);

