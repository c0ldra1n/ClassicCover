//
//  UIImage+Graphics.m
//  ClassicCover
//
//  Created by c0ldra1n on 10/26/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "UIImage+Graphics.h"



UIImage * blurImage(UIImage *sourceImage, float radius){
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    

    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    
    if (cgImage) {
        CGImageRelease(cgImage);
    }
    
    return retVal;
    
}

UIColor * colorWithMinimumSaturation(UIColor *self, double saturation){
    
    if (!self)
        return nil;
    
    CGFloat h, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    
    if (s < saturation)
        return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
    
    return self;
    
}

UIColor * averageColor(UIImage *image, double alpha){
    
    //Work within the RGB colorspoace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //Draw our image down to 1x1 pixels
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    //Check if image alpha is 0
    if (rgba[3] == 0) {
        
        CGFloat imageAlpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = imageAlpha/255.0;
        
        UIColor *averageColor = [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier green:((CGFloat)rgba[1])*multiplier blue:((CGFloat)rgba[2])*multiplier alpha:imageAlpha];
        
        //Improve color
        averageColor = colorWithMinimumSaturation(averageColor, 0.15);
        
        //Return average color
        return averageColor;
    }
    
    else {
        
        //Get average
        UIColor *averageColor = [UIColor colorWithRed:((CGFloat)rgba[0])/255.0 green:((CGFloat)rgba[1])/255.0 blue:((CGFloat)rgba[2])/255.0 alpha:alpha];
        
        //Improve color
        averageColor = colorWithMinimumSaturation(averageColor, 0.15);
        
        //Return average color
        return averageColor;
    }
}


@implementation UIImage (Graphics)

-(UIImage *)blurredImageWithRadius:(float)radius{
    return blurImage(self, radius);
}

-(UIColor *)averageColor{
    return averageColor(self, 1.f);
}

-(UIImage *)colorizeWithColor:(UIColor *)color {
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, self.CGImage);
    
    [color set];
    CGContextFillRect(context, area);
    
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextDrawImage(context, area, self.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

@end
