

EMPTY:=
COMMA:=,
SPACE:= $(EMPTY) $(EMPTY)


KVER:=k404


compile := sudo ./compile.sh
compile += NO_APT_CACHER=yes


# https://docs.armbian.com/Developer-Guide_Build-Options
# compile += KERNEL_CONFIGURE=yes
compile += KERNEL_KEEP_CONFIG=yes
compile += KERNEL_EXPORT_DEFCONFIG=yes

compile += BOOTDELAY=2

compile += BOOTSIZE=128
compile += BRANCH=default
compile += BUILD_KSRC=no


ifeq ($(KVER), k404)
  compile += LIB_TAG=rk3328
  compile += BOARD=rock64
  compile += ARMBIANSERVER="mirrors.miwifi.io/armbian"
  compile += UBUNTU_MIRROR="mirrors.cloud.tencent.com/ubuntu-ports/"
else
  compile += BOARD=rock64
  compile += ARMBIANSERVER="mirrors.miwifi.io/armbian"
  compile += UBUNTU_MIRROR="mirrors.cloud.tencent.com/ubuntu-ports/"
endif



.PHONY: all config kernel bionic

all: kernel

config:
	rm -f output userpatches
	ln -sf /adisk/snail/armbian/Build-Armbian_Rock64/output output
	ln -sf /adisk/snail/armbian/Build-Armbian_Rock64/userpatches userpatches


kernel:
	$(compile) BUILD_DESKTOP=no KERNEL_CONFIGURE=yes KERNEL_ONLY=yes RELEASE=bionic


bionic:
	$(compile) BUILD_DESKTOP=no KERNEL_CONFIGURE=no KERNEL_ONLY=no RELEASE=$@
	@if [ -d /home/armbian/rock64/.tmp/rootfs-default-rock64-bionic-no ]; then \
		sudo umount -l /home/armbian/rock64/.tmp/rootfs-default-rock64-bionic-no/tmp/overlay || true; \
		sudo umount -l /home/armbian/rock64/.tmp/rootfs-default-rock64-bionic-no || true; \
		rmdir /home/armbian/rock64/.tmp/rootfs-default-rock64-bionic-no 2>/dev/null || true; \
	else true; fi


