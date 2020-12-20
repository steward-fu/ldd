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

void softirq_handler(struct softirq_action *action)
{
  printk("%s\n", __func__);
}

static irqreturn_t irq_handler(int irq, void *arg)
{
  raise_softirq(POCKETBEAGLE_SOFTIRQ);
  return IRQ_HANDLED;
}

int ldd_init(void)
{
  request_irq(gpio_to_irq(BUTTON), irq_handler, IRQF_TRIGGER_RISING, "gpio_irq", NULL);
  open_softirq(POCKETBEAGLE_SOFTIRQ, softirq_handler);
  return 0;
}
 
void ldd_exit(void)
{
  raise_softirq_irqoff(POCKETBEAGLE_SOFTIRQ);
  free_irq(gpio_to_irq(BUTTON), NULL);
}
 
module_init(ldd_init);
module_exit(ldd_exit);

