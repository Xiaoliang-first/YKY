//
//  bottomLineBtn.m
//  YKY
//
//  Created by 肖 亮 on 16/4/14.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "bottomLineBtn.h"

@implementation bottomLineBtn


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(void)setColor:(UIColor *)color{
    lineColor = [color copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGRect textRect = self.titleLabel.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();

    CGFloat descender = self.titleLabel.font.descender;
    if([lineColor isKindOfClass:[UIColor class]]){
        CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
    }
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+1);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender+1);

    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
