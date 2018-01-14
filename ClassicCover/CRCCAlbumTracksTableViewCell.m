//
//  CRCCAlbumTracksTableViewCell.m
//  ClassicCover
//
//  Created by c0ldra1n on 9/2/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "CRCCAlbumTracksTableViewCell.h"

@implementation CRCCAlbumTracksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsUpdateConstraints];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    if(highlighted){
        if(animated){
            [UIView animateWithDuration:0.1 animations:^{
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            }];
        }else{
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        }
    }else{
        if(animated){
            [UIView animateWithDuration:0.1 animations:^{
                self.backgroundColor = [UIColor clearColor];
            }];
        }else{
                self.backgroundColor = [UIColor clearColor];
        }
    }
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
//    [self setHighlighted:selected animated:animated];
}

@end
