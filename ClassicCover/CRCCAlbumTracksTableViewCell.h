//
//  CRCCAlbumTracksTableViewCell.h
//  ClassicCover
//
//  Created by c0ldra1n on 9/2/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRCCAlbumTracksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLengthLabel;

@end
