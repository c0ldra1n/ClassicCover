//
//  CRCCPrefsManager.m
//  ClassicCover
//
//  Created by c0ldra1n on 1/1/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import "CRCCPrefsManager.h"
#import "./iCarousel/iCarousel.h"

#define kCCPreferencesPath @"/var/mobile/Library/Preferences/io.c0ldra1n.classiccover-prefs.plist"

NSString * const kCRCCPrefsEnabledKey = @"enabled";

NSString * const kCRCCPrefsCoverStyleKey = @"cover_style";

NSString * const kCRCCPrefsBackgroundStyleKey = @"background_style";
NSString * const kCRCCPrefsBackgroundKey = @"background";

NSString * const kCRCCPrefsArtworkSizeKey = @"artwork_size";

NSString * const kCRCCPrefsSortKey = @"sort_by";

static CRCCPrefsManager *sharedManager;

@implementation CRCCPrefsManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reload];
    }
    return self;
}

-(void)reload{
    _preferences = ([[NSDictionary alloc] initWithContentsOfFile:kCCPreferencesPath] ?: @{});
    _defaults = @{
                  kCRCCPrefsEnabledKey: @(YES),
                  kCRCCPrefsCoverStyleKey:@(iCarouselTypeCoverFlow),
                  kCRCCPrefsBackgroundStyleKey:@(CRCCBackgroundStyleColor),
                  kCRCCPrefsBackgroundKey:@"#333333",
                  kCRCCPrefsArtworkSizeKey:@(CRCCArtworkSizeBig),
                  kCRCCPrefsSortKey:@(CRCCSortMethodArtist)
                  };
}

-(id)valueForPreferenceKey:(NSString *)key{
    
    if([[_preferences allKeys] containsObject:key]){
        return [_preferences objectForKey:key];
    }else if([[_defaults allKeys] containsObject:key]){
        return [_defaults objectForKey:key];
    }
    
    return nil;
}

+(CRCCPrefsManager *)sharedManager{
    return sharedManager;
}

+(void)initialize{
    static BOOL prefs_init;
    if (!prefs_init) {
        sharedManager = [[CRCCPrefsManager alloc] init];
        prefs_init = true;
    }
}

+(void)load{
    [CRCCPrefsManager initialize];
}

@end
