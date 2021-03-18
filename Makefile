
include $(TOPDIR)/rules.mk

PKG_NAME:=cloudpan189
PKG_VERSION:=0.0.9
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=7ead4d1c08bd94045ae012ce2c35d67d3678b74e
PKG_SOURCE_URL:=https://github.com/tickstep/cloudpan189-go
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/config
menu "Cloud Configuration"

config PACKAGE_$(PKG_NAME)_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n
	
config PACKAGE_$(PKG_NAME)_UPX
	bool "Compress executable files with UPX"
	default y

endmenu
endef

define Package/$(PKG_NAME)
  TITLE:=Cloud Disk CLI
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=Cloud
endef

define Package/$(PKG_NAME)/description
cloud disk command line client
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
