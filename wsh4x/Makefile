target = appletv::12.1
DEBUG=1
THEOS_DEVICE_IP = bedroom.local
INSTALL_TARGET_PROCESSES = WireGuardtvOS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = wsh4x

wsh4x_FILES = Tweak.x
wsh4x_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
