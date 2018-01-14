include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ClassicCover
ClassicCover_FILES = $(wildcard *.*m*) ./ClassicCover/CRCCPrefsManager.m

$(TWEAK_NAME)_CFLAGS += -D THEOSBUILD=1 -D HBLogError=NSLog -w
$(TWEAK_NAME)_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music"
	install.exec "open com.apple.Music"

SUBPROJECTS += ClassicCover

SUBPROJECTS += classiccoverprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
