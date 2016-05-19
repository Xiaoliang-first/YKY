//
//  navBtn.m
//  YKY
//
//  Created by 肖亮 on 15/11/25.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "navBtn.h"

@implementation navBtn



-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 17, 17)];
        imgView.image = [UIImage imageNamed:self.imgName];
        [self addSubview:imgView];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, 43, 20)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor darkGrayColor];
        title.text = self.btnTitle;
        [self addSubview:title];
        
    }
    return self;
}

@end
