
include $(TOPDIR)/rules.mk

PKG_NAME:=cloudpan189
PKG_VERSION:=0.0.9
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE



PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=Cloud Disk CLI
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
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

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/$(PKG_NAME) $(1)/etc/uci-defaults/99-$(PKG_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
