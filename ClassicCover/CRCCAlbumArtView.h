//
//  CRCCAlbumArtView.h
//  ClassicCover
//
//  Created by c0ldra1n on 8/26/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CRCCAlbumDetailViewController.h"

@class CRCCAlbumArtView;

@protocol CRCCAlbumArtViewDelegate <NSObject>
@required
-(void)albumArtView:(CRCCAlbumArtView *)view didFlip:(BOOL)flip;
-(void)albumArtView:(CRCCAlbumArtView *)view willFlip:(BOOL)flip;
@end

@interface CRCCAlbumArtView : UIView {
    UIView *_contentView;
}

@property id<CRCCAlbumArtViewDelegate> delegate;
@property MPMediaItemCollection *album;
@property UIImageView *artworkView;
@property CRCCAlbumDetailView *flipView;
@property CRCCAlbumDetailViewController *flipViewController;

-(void)setActive:(BOOL)active animated:(BOOL)animated;

-(void)prepareForReuse;

-(void)flip:(BOOL)flag;

@end
