//
//  CRCCAlbumDetailView.m
//  ClassicCover
//
//  Created by c0ldra1n on 9/2/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "CRCCAlbumDetailView.h"
#import "CRCCAlbumArtView.h"

@implementation CRCCAlbumDetailView

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipSuperView)]; 
    [self.barView addGestureRecognizer:tap];
    
    for (UIView *subview in self.trackTableView.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"])
        {
            subview.frame = CGRectMake(0, 0, self.trackTableView.bounds.size.width, self.trackTableView.bounds.size.height);
        }
    }
}

-(void)flipSuperView{
    [self.albumArtView flip:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
