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

+(UIView*)addTheMoreViewWithY:(CGFloat)Y andVc:(homeVC*)VC andAction:(SEL)action{
    //backView
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, Y, VC.view.width, 41)];
    view.backgroundColor = [UIColor whiteColor];
    [VC.backScrollerView addSubview:view];

    //底线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, view.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:217.0/255.0f green:217.0/255.0f blue:217.0/255.0f alpha:1.0f];
    [view addSubview:line];

    //重磅推出
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 200, 17)];
    la.text = @"随意摇奖品展示";
    la.textAlignment = NSTextAlignmentLeft;
    la.font = [UIFont systemFontOfSize:[myFont getTitle1]];
    la.textColor = [UIColor redColor];
    [view addSubview:la];

    UIView * theMoreBackView = [[UIView alloc]initWithFrame:CGRectMake(VC.view.width-35-36, la.y+4, 13+33+8, 13)];
    theMoreBackView.backgroundColor = YKYClearColor;
    [view addSubview:theMoreBackView];

    //更多按钮
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(theMoreBackView.width-13, 0, 13, 13)];
    imgView.image = [UIImage imageNamed:@"theMore"];
    [theMoreBackView addSubview:imgView];

    UILabel * moreL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 13)];
    moreL.textColor = [UIColor blackColor];
    moreL.textAlignment = NSTextAlignmentRight;
    moreL.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    moreL.text = @"更多";
    [theMoreBackView addSubview:moreL];


    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, -15 , 54, 40)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    [theMoreBackView addSubview:btn];

    return theMoreBackView;
}


@end
