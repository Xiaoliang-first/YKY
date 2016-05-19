//
//  rightDownLocationBtn.m
//  YKY
//
//  Created by 肖亮 on 15/12/14.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "rightDownLocationBtn.h"
#import "UIView+XL.h"
#import "MBProgressHUD+MJ.h"

@implementation rightDownLocationBtn

+(void)addLocationBtnWithSuperView:(UIScrollView *)scrollView andLeftView:(UILabel *)leftLabel andAction:(SEL)action andViewController:(UIViewController *)VC{

    CGFloat W = 30;
    //定位标志图片btn
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0.5*(VC.view.width-W), leftLabel.y+2*W, 29, W)];
    [btn setImage:[UIImage imageNamed:@"dingwei-1"] forState:UIControlStateNormal];
    
    //一键导航文字label
    UILabel * laLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.centerX-35, btn.y+btn.height+4, 70, 20)];
    laLabel.text = @"一键导航";
    laLabel.textAlignment = NSTextAlignmentCenter;
    laLabel.font = [UIFont systemFontOfSize:14];


    //覆盖btn方便点击跳转到map界面
    UIButton * bigBtn = [[UIButton alloc]initWithFrame:CGRectMake(laLabel.x, btn.y, laLabel.width, laLabel.height+btn.height+5)];
    bigBtn.backgroundColor = [UIColor clearColor];
    [bigBtn addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
   
    //添加控件到滚动视图上
    [scrollView addSubview:btn];
    [scrollView addSubview:laLabel];
    [scrollView addSubview:bigBtn];
    
    [MBProgressHUD hideHUDForView:VC.view animated:YES];
}

@end
