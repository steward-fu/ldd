#include <linux/init.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/delay.h>
#include <linux/kthread.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Steward Fu");
MODULE_DESCRIPTION("Linux Driver");

struct task_struct *mykthread=NULL;

static int kthread_handler(void *data)
{
  printk("%s++\n", __func__);
  while(!kthread_should_stop()) {
    msleep(100);
  }
  printk("%s--\n", __func__);
  return 0;
}

int ldd_init(void)
{
  mykthread = kthread_create(kthread_handler, NULL, "mykthread");
  wake_up_process(mykthread);
  return 0;
}
 
void ldd_exit(void)
{
  kthread_stop(mykthread);
}
 
module_init(ldd_init);
module_exit(ldd_exit);

