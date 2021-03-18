include $(TOPDIR)/rules.mk

PKG_NAME:=cloudpan189
PKG_VERSION:=0.0.9
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/tickstep/cloudpan189-go
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_CONFIG_DEPENDS:= \
	CONFIG_CLOUDPAN_GOPROXY \
	CONFIG_CLOUDPAN_UPX

GO_PKG:=github.com/tickstep/cloudpan189-go
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/core.version=$(PKG_VERSION) \
	$(GO_PKG)/core.codename=OpenWrt


include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)
  TITLE:=Cloud Disk CLI
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-certificates
endef

define Package/$(PKG_NAME)/description
cloud disk command line client
endef

define Package/$(PKG_NAME)/config
menu "Cloud Configuration"
	depends on config

config CONFIG_CLOUDPAN_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n
	
config CONFIG_CLOUDPAN_UPX
	bool "Compress executable files with UPX"
	default y
 
endmenu
endef

ifeq ($(CONFIG_CLOUDPAN_GOPROXY),y)
export GO111MODULE=on
export GOPROXY=https://goproxy.io
endif

define Build/Compile
	$(eval GO_PKG_BUILD_PKG:=$(GO_PKG))
	$(call GoPackage/Build/Compile)
ifeq ($(CONFIG_CLOUDPAN_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/cloud || true
endif
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/opt/cloud
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/cloud $(1)/opt/cloud
	$(LN) cloud $(1)/opt/cloud/cloud
endef

$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))