//
//  MSBHeaderView.m
//  Musubi
//
//  Created by c0ldra1n on 3/1/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "CCHeaderView.h"

@implementation UIImage (scale)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@implementation CCHeaderView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithBackground:(UIImage *)background overlay:(UIImage *)overlay{
    self = [super init];
    if (self) {
        backgroundImage = background;
        overlayImage = overlay;
        [self initializeImageViews];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    self.overlayView.frame = self.bounds;
    
    self.backgroundView.layer.masksToBounds = true;
    self.overlayView.layer.masksToBounds = true;
    
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.overlayView.contentMode = UIViewContentModeScaleAspectFit;
    
}

#define BLACKBACK
-(void)initializeImageViews{
    
    if (backgroundImage) {
        if (!self.backgroundView) {
            self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
#ifndef BLACKBACK
            self.backgroundView.image = backgroundImage;
#endif
            self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
            self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
            [self addSubview:self.backgroundView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleParallax)];
            
            [self.backgroundView addGestureRecognizer:tap];

        }
    }
    
    if (overlayImage) {
        if (!self.overlayView) {
            self.overlayView = [[UIImageView alloc] initWithFrame:self.bounds];
            self.overlayView.image = overlayImage;
            self.overlayView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:self.overlayView];
        }
    }
}

-(void)toggleParallax{
    NSLog(@"TAP!");
    if(self.overlayView.motionEffects.count > 0){
        [self.overlayView removeMotionEffect:self.overlayView.motionEffects[0]];
    }else{
        //  Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =[[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                           type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-30);
        verticalMotionEffect.maximumRelativeValue = @(30);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =[[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                             type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-30);
        horizontalMotionEffect.maximumRelativeValue = @(30);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to your view
        [self.overlayView addMotionEffect:group];
        
    }
}


-(void)updateScrollPosition:(CGFloat)offset{
    //    self.backgroundView.layer.contentsRect = CGRectMake(0, -offset, backgroundImage.size.width, backgroundImage.size.height);
    
    //    self.backgroundView.layer.contentsCenter = CGRectMake(self.backgroundView.layer.contentsCenter.origin.x, self.backgroundView.layer.contentsCenter.origin.y - offset, self.backgroundView.layer.contentsCenter.size.width, self.backgroundView.layer.contentsCenter.size.height);
}

@end
