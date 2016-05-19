//
//  myCellsRightNoImg.m
//  YKY
//
//  Created by 肖 亮 on 16/4/21.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "myCellsRightNoImg.h"

@implementation myCellsRightNoImg

+(UIView*)addCellWithFrame:(CGRect)frame Title:(NSString*)title titleLabelFont:(CGFloat)num titleColor:(UIColor*)color titleX:(CGFloat)X toView:(UIView*)backView VC:(UIViewController*)VC action:(SEL)action{
    //承载view
    UIView * back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = [UIColor whiteColor];
    [backView addSubview:back];
    //laebl
    CGFloat h = num+4;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, 0.5*(frame.size.height-h), 150, h)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:num];
    label.textColor = color;
    [back addSubview:label];
    //右箭头
    CGFloat imgW = 7;
    CGFloat imgH = 13;
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(back.width-X-imgW, 0.5*(frame.size.height-imgH), imgW, imgH)];
    imgv.image = [UIImage imageNamed:@"jiantou_me"];
    [back addSubview:imgv];

    //btn
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    btn.backgroundColor = YKYClearColor;
    [btn addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:btn];
    if ([title isEqualToString:@"图文详情"]) {
        [line addLineWithFrame:CGRectMake(X, frame.size.height-1, frame.size.width-X, 1) andBackView:back];
    }
    return back;
}

@end
