//
//  CRCCAlbumArtView.m
//  ClassicCover
//
//  Created by c0ldra1n on 8/26/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "CRCCAlbumArtView.h"
#define CRCCBundlePath @"/Library/Application\ Support/ClassicCover/ClassicCover.bundle"

@interface CRCCAlbumArtView () {
    CGRect origFrame;
    CGRect flipFrame;
    CGPoint origCenter;
    BOOL origSet;
    
    BOOL flipped;
    
}

@end


@implementation CRCCAlbumArtView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        origFrame = frame;
        
        self.artworkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,  frame.size.width)];
        
        self.artworkView.center = self.center;
        
        [self addSubview:_artworkView];
        
        flipFrame = CGRectMake(0, 0, (frame.size.width/7)*9, (frame.size.width/7)*9);//factor: (x/7)*9
        
    }
    
    return self;
    
}

-(void)prepareForReuse{
    
    if (self.artworkView && ![self.subviews containsObject:self.artworkView]) {
        self.frame = origFrame;
        _artworkView.frame = origFrame;
        [self addSubview:_artworkView];
    }
    
    if (flipped) {
        [self.flipView removeFromSuperview];
    }
    
    self.flipViewController = nil;
    self.flipView = nil;
}

-(void)setActive:(BOOL)active animated:(BOOL)animated{
    if (!active) {
        self.backgroundColor = [UIColor blackColor];
        if(animated){
            [UIView animateWithDuration:0.5 animations:^{
                self.artworkView.alpha = 0.5;
            } completion:^(BOOL completion){
                [self setUserInteractionEnabled:NO];
            }];
        }else{
            self.artworkView.alpha = 0.5;
            [self setUserInteractionEnabled:NO];
        }
    }else{
        if(animated){
            [UIView animateWithDuration:0.5 animations:^{
                self.artworkView.alpha = 1.0;
            } completion:^(BOOL completion){
                [self setUserInteractionEnabled:YES];
            }];
        }else{
            self.backgroundColor = [UIColor clearColor];
            self.artworkView.alpha = 1.0;
            [self setUserInteractionEnabled:YES];
        }
    }
}


-(void)flip:(BOOL)flag{
    
    if(flipped == flag)     return;
    
    [self.window setUserInteractionEnabled:NO];
    
    self.backgroundColor = [UIColor clearColor];
    
    if(self.delegate){
        [self.delegate albumArtView:self willFlip:!flipped];
    }
    
    if(!self.flipViewController){
#ifdef THEOSBUILD
        self.flipViewController = [[UIStoryboard storyboardWithName:@"ClassicCover" bundle:[NSBundle bundleWithPath:CRCCBundlePath]] instantiateViewControllerWithIdentifier:@"albumTracksViewController"];
#else
        self.flipViewController = [[UIStoryboard storyboardWithName:@"ClassicCover" bundle:nil] instantiateViewControllerWithIdentifier:@"albumTracksViewController"];
#endif
        
        self.flipViewController.album = self.album;
        self.flipView = self.flipViewController.view;
        self.flipView.albumArtView = self;
        self.flipView.frame = flipFrame;
        
    }
    
    if(!origSet){
        origCenter = self.center;
        origSet = true;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(flag){
            //  flip
            self.frame = flipFrame;
            self.center = origCenter;
//          self.center = CGPointMake(origCenter.x, origCenter.y + (origFrame.size.width/(7*2)));
            
            [UIView transitionWithView:self duration:0.75 options:(UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent) animations:^{
                
                    [self.artworkView removeFromSuperview];
                    self.flipView.frame = flipFrame;
                    [self addSubview:self.flipView];
                    
                
            } completion:^(BOOL finished){
                
                flipped = !(self.artworkView.superview != nil);
                
                if(self.delegate){
                    [self.delegate albumArtView:self didFlip:flipped];
                }
                [self.window setUserInteractionEnabled:YES];
                
            }];
            
            
        }else{
            //  unflip
            self.center = origCenter;
            
            [UIView transitionWithView:self duration:0.75 options:(UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent) animations:^{
                
                [self.flipView removeFromSuperview];
                self.frame = origFrame;
                self.artworkView.frame = origFrame;
                [self addSubview:_artworkView];
                
                
            } completion:^(BOOL finished){
                
                flipped = !(self.artworkView.superview != nil);
                
                if(self.delegate){
                    [self.delegate albumArtView:self didFlip:flipped];
                }
                
                [self.window setUserInteractionEnabled:YES];
                
            }];
            
        }
        
    });
    
    NSLog(@"Flipped: %d\n", flipped);

    
}

@end
