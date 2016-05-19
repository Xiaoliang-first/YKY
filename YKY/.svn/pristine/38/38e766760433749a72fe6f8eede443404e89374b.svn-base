//
//  alterView.m
//  YKY
//
//  Created by 肖 亮 on 16/1/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "alterView.h"
#import "UIView+XL.h"
//#import "homeVC.h"

static UIView * backView;
static UIButton * btn;
static UIViewController * fromeVC;

@implementation alterView

+(void)showWithVC:(UIViewController *)VC title:(NSString *)title text:(NSString*)text btnTitle:(NSString *)btnTitle {

    fromeVC = VC;
    //灰色btn背景
    UIButton * bigBlack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, VC.view.width, VC.view.height)];
    bigBlack.backgroundColor = [UIColor blackColor];
    bigBlack.alpha = 0.6;
    [bigBlack addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [VC.view addSubview:bigBlack];
    btn = bigBlack;

    CGFloat x = 30;
    CGFloat h = 0.45*VC.view.height;
    if (VC.view.height > 668) {
        x = 50;
        h = 0.35*VC.view.height;
    }else if (VC.view.height<481){
        x = 25;
        h = 0.52*VC.view.height;
    }
    CGFloat w = VC.view.width-2*x;
    CGFloat y = 0.5*(VC.view.height-h);

    //提示view
    UIView * back = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    back.backgroundColor = [UIColor whiteColor];
    [VC.view addSubview:back];
    back.layer.cornerRadius = 5;
    back.layer.masksToBounds = YES;
    back.layer.borderWidth = 0.01;
    backView = back;

    //top
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, back.width, 44)];
    titleLB.text = title;
    titleLB.font = [UIFont systemFontOfSize:17];
    titleLB.textAlignment = NSTextAlignmentLeft;
    titleLB.textColor = [UIColor whiteColor];
    titleLB.backgroundColor = [UIColor redColor];
    [back addSubview:titleLB];

    //midText
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(4, titleLB.height+10, back.width-4, back.height-2*titleLB.height-10)];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor blackColor];
    textView.text = text;
    textView.userInteractionEnabled = NO;
    [back addSubview:textView];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    NSString *string = textView.text;
    NSDictionary *ats = @{NSFontAttributeName : [UIFont systemFontOfSize:15],NSParagraphStyleAttributeName : paragraphStyle,};
    textView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];

    //bottom
    CGFloat bottomW = 0.5*back.width;
    UIButton * agree = [[UIButton alloc]initWithFrame:CGRectMake(0.5*(back.width-bottomW), textView.y+textView.height-5, bottomW, 40)];
    [agree setTitle:btnTitle forState:UIControlStateNormal];
    [agree setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [agree setBackgroundImage:[UIImage imageNamed:@"agreeBack"] forState:UIControlStateNormal];
    [agree addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:agree];

}

+(void)dissMiss{
    [backView removeFromSuperview];
    [btn removeFromSuperview];
    fromeVC.navigationController.navigationBar.userInteractionEnabled = YES;
    fromeVC.tabBarController.tabBar.hidden = NO;
}


@end
