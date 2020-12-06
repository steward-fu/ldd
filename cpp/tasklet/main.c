#include <linux/init.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/delay.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/gpio.h>
#include <linux/interrupt.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Steward Fu");
MODULE_DESCRIPTION("Linux Driver");
 
#define BUTTON 27

struct tasklet_struct mytask={0};

void tasklet_handler(unsigned long data)
{
  printk("%s\n", __func__);
}

static irqreturn_t irq_handler(int irq, void *arg)
{
  tasklet_schedule(&mytask);
  return IRQ_HANDLED;
}

int ldd_init(void)
{
  int irq=0;

  tasklet_init(&mytask, tasklet_handler, 0);
  irq = gpio_to_irq(BUTTON);
  if(request_irq(irq, irq_handler, IRQF_TRIGGER_RISING, "gpio_irq", NULL)){
    printk("%s, failed to request irq(%d)\n", __func__, irq);
  }
  return 0;
}
 
void ldd_exit(void)
{
  int irq=0;
  
  irq = gpio_to_irq(BUTTON);
  free_irq(irq, NULL);
  tasklet_kill(&mytask);
}
 
module_init(ldd_init);
module_exit(ldd_exit);

