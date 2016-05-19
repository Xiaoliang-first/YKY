//
//  line.m
//  YKY
//
//  Created by 肖 亮 on 16/4/7.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "line.h"

@implementation line

+(void)addLineWithFrame:(CGRect)frame andBackView:(UIView *)backView {
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = YKYColor(242, 242, 242);
    [backView addSubview:line];
}

@end
