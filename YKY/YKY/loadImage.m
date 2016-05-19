//
//  loadImage.m
//  02-肖亮微博
//
//  Created by xiaoliang on 15/2/28.
//  Copyright (c) 2015年 肖亮. All rights reserved.
//

#import "loadImage.h"
#import "common.h"

@implementation loadImage


/**
 *  拉伸图片
 *
 *  @param name 要拉伸的图片名
 *
 *  @return 被拉伸完成的图片
 */
+ (UIImage *)resizedImage:(NSString *)name width:(CGFloat)multipleW height:(CGFloat)multipleH {
    
    UIImage *img = [loadImage imageNamed:name];

    [img stretchableImageWithLeftCapWidth:img.size.width * multipleW topCapHeight:img.size.height * multipleH];
    
    return img;
}

@end
