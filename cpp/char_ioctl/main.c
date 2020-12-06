#include <linux/cdev.h>
#include <linux/init.h>
#include <linux/device.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Steward Fu");
MODULE_DESCRIPTION("Linux Driver");

static int base=0;
static struct cdev mycdev;
static struct class *myclass=NULL;

static int myopen(struct inode *inode, struct file *file)
{
  printk("%s\n", __func__);
  return 0;
}

static int myclose(struct inode *inode, struct file *file)
{
  printk("%s\n", __func__);
  return 0;
}

static long myioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
  printk("%s, 0x%x\n", __func__, cmd);
  return 0;
}

static const struct file_operations myfops = {
  .owner = THIS_MODULE,
  .open = myopen,
  .release = myclose,
  .unlocked_ioctl = myioctl,
};

int ldd_init(void)
{
  alloc_chrdev_region(&base, 0, 1, "myfile");
  myclass = class_create(THIS_MODULE, "myfile");
  device_create(myclass, NULL, base, NULL, "myfile");
  cdev_init(&mycdev, &myfops);
  cdev_add(&mycdev, base, 1);
  return 0;
}
 
void ldd_exit(void)
{
  cdev_del(&mycdev);
  device_destroy(myclass, base);
  class_destroy(myclass);
  unregister_chrdev_region(base, 1);
}
 
module_init(ldd_init);
module_exit(ldd_exit);

