//
//  WMIrregularButton.m
//
//  Created by Adam Howard on 06/03/2013.
//  Copyright (c) 2013 WMAS. All rights reserved.
//

#import "WMIrregularButton.h"

@interface WMIrregularButton () {
    UIImage *_image;
    NSData *_imageData;
}

@end

@implementation WMIrregularButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// This will allow nib support
- (id) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setImageMask];
    }
    
    return self;
}

// We'll want to reload when the image is changed
- (void) setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self setImageMask];
}

// Return the offset for the alpha pixel at (x,y) for RGBA
// 4-bytes-per-pixel bitmap data
static NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w) {return y * w * 4 + x * 4;}

// Override hit detection. Does the point hit the mask?
- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!CGRectContainsPoint(self.bounds, point)) return NO;
    Byte *bytes = (Byte *)_imageData.bytes;
    uint offset = alphaOffset(point.x, point.y, _image.size.width);
    return bytes[offset] > 0;
}

- (void) setImageMask {
    _image = [self imageForState:UIControlStateNormal];
    if (_image == nil) return;
    
    float widthDiff = _image.size.width - self.frame.size.width;
    float heightDiff = _image.size.height - self.frame.size.height;
    if (widthDiff > 0.01 || widthDiff < -0.01 || heightDiff > 0.01 || heightDiff < -0.01) {
        NSLog(@"WMIrregularButton: frame doesn't match image size. f:%.0f:%.0f i:%.0f:%.0f", self.frame.size.width, self.frame.size.height, _image.size.width, _image.size.height);
    }

    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return;
    }
    
    CGSize size = _image.size;
    unsigned char *bitmapData = calloc(size.width * size.height * 4, 1);
    if (bitmapData == NULL) { 
        NSLog(@"Error: Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return;
    }
    
    CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                  size.width, size.height, 8, size.width * 4, colorSpace,
                                                  kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        NSLog(@"Error: Context not created!");
        free(bitmapData);
        return;
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGContextDrawImage(context, rect, _image.CGImage);
    unsigned char *data = CGBitmapContextGetData(context);
    CGContextRelease(context);
    
    _imageData = [NSData dataWithBytes:data length:size.width * size.height * 4];
    free(bitmapData);
}

@end
