OPTEE_EXAMPLES_VERSION = 1.0
OPTEE_EXAMPLES_SOURCE = local
OPTEE_EXAMPLES_SITE = $(TOPDIR)/../optee_examples
OPTEE_EXAMPLES_SITE_METHOD = local
OPTEE_EXAMPLES_INSTALL_STAGING = YES
OPTEE_EXAMPLES_DEPENDENCIES = optee_client
OPTEE_EXAMPLES_SDK = $(BR2_PACKAGE_OPTEE_EXAMPLES_SDK)
OPTEE_EXAMPLES_CONF_OPTS = -DOPTEE_EXAMPLES_SDK=$(OPTEE_EXAMPLES_SDK)

define OPTEE_EXAMPLES_BUILD_TAS
	@$(foreach f,$(wildcard $(@D)/*/ta/Makefile), \
		$(MAKE) CROSS_COMPILE="$(shell echo $(BR2_PACKAGE_OPTEE_EXAMPLES_CROSS_COMPILE))" \
			O=out TA_DEV_KIT_DIR=$(OPTEE_EXAMPLES_SDK) V=1 \
			$(TARGET_CONFIGURE_OPTS) -C $(dir $f) all &&) true
endef

define OPTEE_EXAMPLES_INSTALL_TAS
	@$(foreach f,$(wildcard $(@D)/*/ta/out/*.ta), \
		$(INSTALL) -v -D -p  --mode=444 \
			--target-directory=$(TARGET_DIR)/lib/optee_armtz $f \
			&&) true
endef

OPTEE_EXAMPLES_POST_BUILD_HOOKS += OPTEE_EXAMPLES_BUILD_TAS
OPTEE_EXAMPLES_POST_INSTALL_TARGET_HOOKS += OPTEE_EXAMPLES_INSTALL_TAS

$(eval $(cmake-package))
