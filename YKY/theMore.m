//
//  theMore.m
//  YKY
//
//  Created by 肖 亮 on 16/1/4.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
/********************添加更多的本期大奖*********************/
//

#import "theMore.h"
#import "UIView+XL.h"
#import "homeVC.h"

@implementation theMore

+(void)addTheMoreViewWithY:(CGFloat)Y andVc:(homeVC*)VC andAction:(SEL)action {
    //backView
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, Y, VC.view.width, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [VC.backScrollerView addSubview:view];

    //底线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, view.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:217.0/255.0f green:217.0/255.0f blue:217.0/255.0f alpha:1.0f];
    [view addSubview:line];

    //重磅推出
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, 200, 17)];
    la.text = @"随意摇奖品展示";
    la.textAlignment = NSTextAlignmentLeft;
    la.font = [UIFont systemFontOfSize:[myFont getTitle1]];
    la.textColor = [UIColor redColor];
    [view addSubview:la];

    //更多按钮
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(VC.view.width-35, la.y+4, 13, 13)];
    imgView.image = [UIImage imageNamed:@"theMore"];
    [view addSubview:imgView];

    UILabel * moreL = [[UILabel alloc]initWithFrame:CGRectMake(imgView.x-36, imgView.y, 33, 13)];
    moreL.textColor = [UIColor blackColor];
    moreL.textAlignment = NSTextAlignmentRight;
    moreL.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    moreL.text = @"更多";
    [view addSubview:moreL];

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(moreL.x, moreL.y, moreL.width+imgView.width+8, 13)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

}


@end
