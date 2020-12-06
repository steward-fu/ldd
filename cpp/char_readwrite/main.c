#include <linux/cdev.h>
#include <linux/init.h>
#include <linux/device.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Steward Fu");
MODULE_DESCRIPTION("Linux Driver");

static int base=0;
static struct cdev mycdev;
static char mybuf[255]={0};

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

static ssize_t myread(struct file *flip, char __user *buf, size_t len, loff_t *off)
{
  return copy_to_user(buf, mybuf, strlen(mybuf));
}

static ssize_t mywrite(struct file *flip, const char __user *buf, size_t len, loff_t *off)
{
  return copy_from_user(mybuf, buf, len);
}

static const struct file_operations myfops = {
  .owner = THIS_MODULE,
  .open = myopen,
  .read = myread,
  .write = mywrite,
  .release = myclose,
};

int ldd_init(void)
{
  alloc_chrdev_region(&base, 0, 1, "myfile");
  cdev_init(&mycdev, &myfops);
  cdev_add(&mycdev, base, 1);
  printk("major:%d, minor:%d\n", MAJOR(base), MINOR(base));
  return 0;
}
 
void ldd_exit(void)
{
  cdev_del(&mycdev);
  unregister_chrdev_region(base, 1);
}
 
module_init(ldd_init);
module_exit(ldd_exit);

