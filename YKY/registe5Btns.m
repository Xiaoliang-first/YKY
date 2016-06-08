//
//  registe5Btns.m
//  YKY
//
//  Created by 肖亮 on 15/12/14.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "registe5Btns.h"
#import "registModel.h"
#import "homeVC.h"
#import "UIView+XL.h"
#import "STScratchView.h"
#import "Account.h"
#import "AccountTool.h"

/** 签到背景的Btn */
static UIButton * Btn;
/** 签到提示图的背景View */
static UIView * alterView;
/** 签到小叉子 */
static UIButton * smallCancelBtn;
/** 确认签到按钮 */
static UIButton * okRegistBtn;
/** 签到backView */
static UIView * registBackView;
/** 签到获取的银币数Label */
static UILabel * addSilverLabel;


@implementation registe5Btns


+(void)addToVC:(UIViewController *)VC {
    
    //0.0删除通知，防止重复签到
    [[NSNotificationCenter defaultCenter] removeObserver:VC name:@"qiandao" object:nil];

    //1.0添加背景大Btn（半透明黑色）
    Btn = [[UIButton alloc]init];
    Btn.frame = CGRectMake(0, 0, VC.view.frame.size.width, VC.view.frame.size.height);
    Btn.backgroundColor = [UIColor blackColor];
    Btn.alpha = kalpha;
    [Btn addTarget:self action:@selector(dissMess) forControlEvents:UIControlEventTouchUpInside];
    [VC.view addSubview:Btn];
    
    //1.1添加签到提示图的背景View
    alterView = [[UIView alloc]init];
    //1.2提示试图frame位置设置
    CGFloat altViewW = VC.view.frame.size.width*0.7;
    CGFloat altViewH = VC.view.frame.size.height*0.4;
    CGFloat altViewX = (VC.view.frame.size.width - altViewW)/2;
    CGFloat altViewY = (VC.view.frame.size.height - altViewH)/2;
    alterView.backgroundColor = [UIColor clearColor];
    alterView.frame = CGRectMake(altViewX, altViewY, altViewW, altViewH);
    [VC.view insertSubview:alterView aboveSubview:Btn];
    
    //1.3添加提示图背景图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hongbaobeijing"]];
    imageView.frame = CGRectMake(0, 0, alterView.frame.size.width, alterView.frame.size.height);
    [alterView addSubview:imageView];


    //2.0添加红框背景View
    CGFloat redBackViewW = altViewW*0.6;
    CGFloat redBackViewH = altViewH*0.2;
    CGFloat redBackViewX = (altViewW-redBackViewW)/2;
    CGFloat redBackViewY = (altViewH-redBackViewH-redBackViewX+6);
    UIView * redBackView = [[UIView alloc]initWithFrame:CGRectMake(redBackViewX, redBackViewY, redBackViewW, redBackViewH)];
    redBackView.backgroundColor = [UIColor clearColor];
    [alterView addSubview:redBackView];


    //2.1添加红框
    UIImageView * redView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, redBackViewW, redBackViewH)];
    redView.image = [UIImage imageNamed:@"hongkuang"];
    [redBackView addSubview:redView];


    //2.2添加红框里的文字
    addSilverLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 0, 0.4*redBackViewW-4, redBackViewH)];
    addSilverLabel.textColor = [UIColor whiteColor];
    addSilverLabel.font = [UIFont boldSystemFontOfSize:20];
    addSilverLabel.text = @"0";
    addSilverLabel.textAlignment = NSTextAlignmentRight;
    [redBackView addSubview:addSilverLabel];

    //2.3添加个图片
    UIImageView * yinbi = [[UIImageView alloc]initWithFrame:CGRectMake(addSilverLabel.x+addSilverLabel.width+8, 0.33*redBackViewH, 0.3*redBackViewW, 0.35*redBackViewH)];
    yinbi.image = [UIImage imageNamed:@"youyinbi"];
    [redBackView addSubview:yinbi];


    //2.4设置遮盖图片
    UIImageView * zhegaiV = [[UIImageView alloc]initWithFrame:CGRectMake(redView.x+8, redView.y+6, redView.width-16, redView.height-12)];
    [zhegaiV setImage:[UIImage imageNamed:@"huikuang"]];

    //2.5设置可刮掉图层
    STScratchView * top = [[STScratchView alloc]initWithFrame:CGRectMake(zhegaiV.x, zhegaiV.y, zhegaiV.width, zhegaiV.height)];
    [redBackView addSubview:top];
    [top setHideView:zhegaiV];
    [top setSizeBrush:20.0];
    [addSilverLabel setText:@"0"];


    //3.0设置签到事件
    [[NSNotificationCenter defaultCenter] addObserver:VC selector:@selector(ok:) name:@"qiandao" object:nil];

    
    //4.0添加X返回按钮
    smallCancelBtn = [[UIButton alloc]init];
    smallCancelBtn.frame = CGRectMake((VC.view.frame.size.width-altViewW)/2+altViewW*0.95, alterView.frame.origin.y, 30, 30);
    [smallCancelBtn setImage:[UIImage imageNamed:@"xiaochazi"] forState:UIControlStateNormal];
    [smallCancelBtn addTarget:self action:@selector(dissMess) forControlEvents:UIControlEventTouchUpInside];
    [VC.view insertSubview:smallCancelBtn aboveSubview:alterView];
    

}
#pragma mark - 设置签到获取的银币数
+(void)setSilverswithText:(NSString*)text{
    addSilverLabel.text = text;
}


+(void)dissMess{
    [alterView removeFromSuperview];
    [registBackView removeFromSuperview];
    [Btn removeFromSuperview];
    [smallCancelBtn removeFromSuperview];
    [okRegistBtn removeFromSuperview];
    [Btn removeFromSuperview];
}



//Account * account = [AccountTool account];
//if ([account.phone isEqualToString:@"15538372390"] || [account.phone isEqualToString:@"13716344285"]) {
//
//}else{
//    //0.0删除通知，防止重复签到
//    [[NSNotificationCenter defaultCenter] removeObserver:VC name:@"qiandao" object:nil];
//}

@end
