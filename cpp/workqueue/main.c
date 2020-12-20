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

struct work_struct mywork={0};
struct workqueue_struct *myworkqueue=NULL;

static void workqueue_handler(struct work_struct *work)
{
  printk("%s\n", __func__);
}

static irqreturn_t irq_handler(int irq, void *arg)
{
  queue_work(myworkqueue, &mywork);
  return IRQ_HANDLED;
}

int ldd_init(void)
{
  myworkqueue = alloc_workqueue("myworkqueue", 0, 0);
  INIT_WORK(&mywork, workqueue_handler);
  request_irq(gpio_to_irq(BUTTON), irq_handler, IRQF_TRIGGER_RISING, "gpio_irq", NULL);
  return 0;
}
 
void ldd_exit(void)
{
  free_irq(gpio_to_irq(BUTTON), NULL);
  destroy_workqueue(myworkqueue);
}
 
module_init(ldd_init);
module_exit(ldd_exit);

