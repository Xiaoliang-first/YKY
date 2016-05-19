//
//  rightImgBtn.m
//  YKY
//
//  Created by 肖 亮 on 16/4/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "rightImgBtn.h"

#define num 2

@implementation rightImgBtn

- (void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType font:(CGFloat)font{

    //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    UIFont *fnt = [UIFont systemFontOfSize:font];
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];;
    [self.imageView setFrame:CGRectMake(0, 0, 20, 25)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,0.85*num*(-titleSize.width-image.size.width))];
    [self setImage:image forState:stateType];


    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:fnt];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,(-image.size.width-titleSize.width)/(1.5*num),0.0,0.0)];
    [self setTitle:title forState:stateType];
}

@end
