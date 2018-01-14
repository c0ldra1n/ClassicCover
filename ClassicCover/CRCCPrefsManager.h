//
//  CRCCPrefsManager.h
//  ClassicCover
//
//  Created by c0ldra1n on 1/1/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CRCCPrefsValueForKey(k) [[CRCCPrefsManager sharedManager] valueForPreferenceKey:k]

extern NSString * const kCRCCPrefsEnabledKey;

extern NSString * const kCRCCPrefsCoverStyleKey;

extern NSString * const kCRCCPrefsBackgroundStyleKey;
extern NSString * const kCRCCPrefsBackgroundKey;

extern NSString * const kCRCCPrefsArtworkSizeKey;

extern NSString * const kCRCCPrefsSortKey;

typedef NS_ENUM(NSInteger, CRCCBackgroundStyle){
    CRCCBackgroundStyleColor = 0,
    CRCCBackgroundStyleImage = 1,
    CRCCBackgroundStyleImageBlur = 2,
    CRCCBackgroundStyleBlur = 3
};

typedef NS_ENUM(NSInteger, CRCCArtworkSize){
    CRCCArtworkSizeBig = 0,
    CRCCArtworkSizeMedium = 1,
    CRCCArtworkSizeSmall = 2
};

typedef NS_ENUM(NSInteger, CRCCSortMethod){
    CRCCSortMethodArtist = 0,
    CRCCSortMethodAlbum
};

@interface CRCCPrefsManager : NSObject {
    NSDictionary *_defaults;
    NSDictionary *_preferences;
}

+(CRCCPrefsManager *)sharedManager;

-(void)reload;

-(id)valueForPreferenceKey:(NSString *)key;

@end
