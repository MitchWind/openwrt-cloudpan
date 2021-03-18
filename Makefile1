
include $(TOPDIR)/rules.mk

PKG_NAME:=cloudpan189
PKG_VERSION:=0.1.0dev
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=7ead4d1c08bd94045ae012ce2c35d67d3678b74e
PKG_SOURCE_URL:=https://github.com/tickstep/cloudpan189-go
PKG_MIRROR_HASH:=d75b5e1e154dd3c4741542a44dcbf01762ebd4dff2df1d343ba8e42ff7a409ab
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_CONFIG_DEPENDS:= \
	CONFIG_CLOUDPAN_GOPROXY \
	CONFIG_CLOUDPAN_UPX

GO_PKG:=github.com/tickstep/cloudpan189-go
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=main.Version=$(PKG_VERSION)
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)/config
menu "Configuration"

config CONFIG_CLOUDPAN_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n
	
config CONFIG_CLOUDPAN_UPX
	bool "Compress executable files with UPX"
	default n

endmenu
endef

ifeq ($(CONFIG_CLOUDPAN_GOPROXY),y)
export GO111MODULE=on
export GOPROXY=https://goproxy.io
endif

define Package/$(PKG_NAME)
  TITLE:=Cloud Disk CLI
  SECTION:=luci
  CATEGORY:=LuCI
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
cloud disk command line client
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
ifeq ($(CONFIG_CLOUDPAN_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/cloud || true
endif
endef

define Build/Configure
endef

define Package/$(PKG_NAME)/install
	$(call GoPackage/Package/Install/Bin,$(1))
endef
$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
