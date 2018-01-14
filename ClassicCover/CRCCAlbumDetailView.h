//
//  CRCCAlbumDetailView.h
//  ClassicCover
//
//  Created by c0ldra1n on 9/2/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRCCAlbumArtView;

@interface CRCCAlbumDetailView : UIView

@property (nonatomic) CRCCAlbumArtView *albumArtView;

@property (nonatomic) IBOutlet UIView *barView;

@property (nonatomic) IBOutlet UIImageView *artworkView;
@property (nonatomic) IBOutlet UIImageView *backgroundArtworkView;

@property (nonatomic) IBOutlet UILabel *artistLabel;
@property (nonatomic) IBOutlet UILabel *albumLabel;

@property (nonatomic) IBOutlet UITableView *trackTableView;

@end
