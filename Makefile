
include $(TOPDIR)/rules.mk

PKG_NAME:=xray-core
PKG_VERSION:=1.4.0
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=4e63c22197683deebb6adc91ebef6b7796131b64
PKG_SOURCE_URL:=https://github.com/XTLS/xray-core.git
PKG_MIRROR_HASH:=09fcfec0b6e9362d36fb358fe781431a6c2baae71a7864eaeb1379977aa22ca9
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_CONFIG_DEPENDS:= \
	CONFIG_CLOUDPAN_GOPROXY \
	CONFIG_CLOUDPAN_UPX

GO_PKG:=github.com/xtls/xray-core
GO_PKG_BUILD_PKG:=github.com/xtls/xray-core/main
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/core.build=OpenWrt \
	$(GO_PKG)/core.version=$(PKG_VERSION)
	
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

define Build/Compile
endef
define Package/$(PKG_NAME)/install
	$(call GoPackage/Package/Install/Bin,$(1))
endef
$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
