//
//  UIColor+fromHex.m
//  Twitter
//
//  Created by Helen Kuo on 3/1/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "UIColor+fromHex.h"

@implementation UIColor (fromHex)
//http://iosdevelopertips.com/conversion/how-to-create-a-uicolor-object-from-a-hex-value.html

+ (UIColor *)colorWithHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexInt];
    
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexInt & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexInt & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexInt & 0xFF))/255
                    alpha:1];
    return color;
}
@end
