include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ClassicCover
ClassicCover_FILES = $(wildcard *.*m*) $(wildcard ./*/*.*m*)
ClassicCover_INSTALL_PATH = /Library/Application Support/ClassicCover/
ClassicCover_FRAMEWORKS = UIKit

ClassicCover_CFLAGS = -fobjc-arc -D THEOSBUILD=1 -D HBLogError=NSLog -w

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)rm -r ./Resources/ClassicCover.storyboardc$(ECHO_END)
	$(ECHO_NOTHING)ibtool --compile ./Resources/ClassicCover.storyboardc ./ClassicCover.storyboard$(ECHO_END)
