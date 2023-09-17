### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Kernel Raviole Android 14 QPR1 {Monolithic}
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=raviole
device.name2=oriole
device.name3=raven
supported.versions=14
'; } # end properties

# boot image installation
block=boot;
is_slot_device=1;
. tools/ak3-core.sh;
split_boot;
flash_boot;

# vendor_kernel_boot installation (for dtb)
block=vendor_boot;
is_slot_device=1;
reset_ak;
split_boot;
flash_boot;

# dtbo installation
flash_generic dtbo;