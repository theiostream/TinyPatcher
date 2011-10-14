THEOS_DEVICE_IP=192.168.1.106

include theos/makefiles/common.mk

TOOL_NAME = TinyPatcher
TinyPatcher_FILES = main.mm

include $(THEOS_MAKE_PATH)/tool.mk
