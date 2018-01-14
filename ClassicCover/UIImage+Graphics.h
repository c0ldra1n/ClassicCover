//
//  UIImage_Graphics.h
//  ClassicCover
//
//  Created by c0ldra1n on 10/26/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Graphics)

-(UIImage *)blurredImageWithRadius:(float)radius;

-(UIColor *)averageColor;

-(UIImage *)colorizeWithColor:(UIColor *)color;

@end
