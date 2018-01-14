include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ClassicCoverPrefs
ClassicCoverPrefs_FILES = $(wildcard *.m)
ClassicCoverPrefs_INSTALL_PATH = /Library/PreferenceBundles
ClassicCoverPrefs_FRAMEWORKS = UIKit
ClassicCoverPrefs_PRIVATE_FRAMEWORKS = Preferences
ClassicCoverPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

ClassicCoverPrefs_LDFLAGS += -F/opt/theos/sdks/iPhoneOS9.3.sdk/System/Library/PrivateFrameworks/

ClassicCoverPrefs_CFLAGS = -fobjc-arc -D THEOSBUILD=1 -D HBLogError=NSLog -w

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ClassicCoverPrefs.plist$(ECHO_END)
