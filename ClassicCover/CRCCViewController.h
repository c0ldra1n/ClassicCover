//
//  CRCCViewController.h
//  ClassicCover
//
//  Created by c0ldra1n on 3/5/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

#import "iCarousel/iCarousel.h"
#import "CRCCAlbumArtView.h"
#import "CRCCPrefsManager.h"
#import "UIColor+Hex.h"

typedef enum : NSUInteger {
    CRCCViewModeAlbum,
    CRCCViewModePlaylist,
    CRCCViewModeArtist,
} CRCCViewMode;

@interface CRCCViewController : UIViewController <iCarouselDelegate, CRCCAlbumArtViewDelegate>{
    NSArray<MPMediaItemCollection *> *_albums;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundWallpaperView;

@property (nonatomic, retain) IBOutlet UILabel *albumNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *albumArtistLabel;

@property (nonatomic, retain) IBOutlet iCarousel *carouselView;

@property (nonatomic, retain) IBOutlet UIButton *playpauseButton;

@property BOOL previewActive;

@end
