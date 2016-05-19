//
//  XLTextLabel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/11.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "XLTextLabel.h"

@implementation XLTextLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.numberOfLines = 0;

    }
    return self;
}

-(void)setFrames:(CGRect)frame{
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [self sizeThatFits:CGSizeMake(frame.size.width, MAXFLOAT)];
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
}


@end
