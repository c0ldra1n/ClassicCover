//
//  CRCCAlbumDetailViewController.h
//  ClassicCover
//
//  Created by c0ldra1n on 9/2/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CRCCAlbumDetailView.h"

@interface CRCCAlbumDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) MPMediaItemCollection *album;

@property (nonatomic,strong) CRCCAlbumDetailView *view;


@end
