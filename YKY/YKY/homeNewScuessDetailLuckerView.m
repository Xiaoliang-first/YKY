//
//  homeNewScuessDetailLuckerView.m
//  YKY
//
//  Created by 肖 亮 on 16/4/21.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeNewScuessDetailLuckerView.h"


///** 获奖者名字 */
//@property (nonatomic , copy) NSString * uname;
///** 获奖者头像url */
//@property (nonatomic , copy) NSString * headUrlStr;
///** 揭晓时间 */
//@property (nonatomic , copy) NSString * luckTimeStr;
///** 摇购时间 */
//@property (nonatomic , copy) NSString * joinTimeStr;
///** 幸运摇码 */
//@property (nonatomic , copy) NSString * luckNumStr;


@implementation homeNewScuessDetailLuckerView

+(UIView*)addViewWithFrame:(CGRect)frame toView:(UIView*)backViuew VC:(UIViewController*)VC JisuanAction:(SEL)action headUrlStr:(NSString*)headUrlStr uname:(NSString*)uname luckTimeStr:(NSString*)luckTimeStr joinTimeStr:(NSString*)joinTimeStr luckNumStr:(NSString*)luckNumStr serials:(NSString*)serials{
    CGFloat magin = 15;
    //主承载view
    UIView * back = [[UIView alloc]initWithFrame:frame];
    [backViuew addSubview:back];
    //背景图
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    imgView.image = [UIImage imageNamed:@"获得者"];
    [back addSubview:imgView];
    //背景中间半圆图
    CGFloat w = 45;
    CGFloat h = 23;
    UIImageView * banyuanImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(back.width-w), 2, w, h)];
    banyuanImgV.image = [UIImage imageNamed:@"获得者banyuan"];
    [back addSubview:banyuanImgV];
    //用户头像
    UIView * userImgBackV = [[UIView alloc]initWithFrame:CGRectMake(magin, 1.7*magin, 50, 50)];
    userImgBackV.backgroundColor = YKYColor(249, 61, 66);
    [back addSubview:userImgBackV];
    //设置图片圆角
    userImgBackV.layer.cornerRadius = 25;
    userImgBackV.layer.masksToBounds = YES;
    userImgBackV.layer.borderWidth = 0.01;
    UIImageView * userImgV = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 48, 48)];
    [userImgV sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:[UIImage imageNamed:@"icon-me"]]; 
    [userImgBackV addSubview:userImgV];
    //设置图片圆角
    userImgV.layer.cornerRadius = 25;
    userImgV.layer.masksToBounds = YES;
    userImgV.layer.borderWidth = 0.01;
    //获奖者label
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(userImgBackV.x+userImgBackV.width+4, userImgBackV.y, 55, 13)];
    label1.text = @"获奖者:";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    label1.textColor = YKYTitleColor;
    [back addSubview:label1];
    UILabel * luckerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.x+label1.width, label1.y, back.width-(label1.x+label1.width)-magin, 13)];
    if (!iPhone6plus) {
        luckerNameLabel.x = luckerNameLabel.x-5;
    }
    if ([phone isMobileNumber:uname]) {
        luckerNameLabel.text = [phoneSecret phoneSecretWithPhoneNum:uname];
    }else{
        luckerNameLabel.text = uname;
    }

    luckerNameLabel.textAlignment = NSTextAlignmentLeft;
    luckerNameLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    luckerNameLabel.textColor = YKYTitleColor;
    [back addSubview:luckerNameLabel];



    //2.1期号//CGRectMake(label2.x, label2.y+label2.height+8, 100, 13)
    UILabel * orderL = [[UILabel alloc]initWithFrame:CGRectMake(label1.x, label1.y+label1.height+8, 100, 13)];
    orderL.text = [NSString stringWithFormat:@"第%@期",serials];
    orderL.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    orderL.textColor = YKYDeTitleColor;
    orderL.textAlignment = NSTextAlignmentLeft;
    [back addSubview:orderL];


    //揭晓时间label//CGRectMake(label1.x, label1.y+label1.height+8, 60, 13)
    UILabel * label2= [[UILabel alloc]initWithFrame:CGRectMake(orderL.x, orderL.y+orderL.height+8, 60, 13)];
    label2.text = @"该期摇购:";
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    label2.textColor = YKYDeTitleColor;
    [back addSubview:label2];
    UILabel * luckTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label2.x+label2.width, label2.y, back.width-(label2.x+label2.width)-magin, 13)];
    if (!iPhone6plus) {
        luckTimeLabel.x = luckTimeLabel.x-5;
    }
    luckTimeLabel.text = [NSString stringWithFormat:@"%@次",luckTimeStr];
    luckTimeLabel.textAlignment = NSTextAlignmentLeft;
    luckTimeLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    luckTimeLabel.textColor = YKYDeTitleColor;
    [back addSubview:luckTimeLabel];


    //摇购时间label
    UILabel * label3= [[UILabel alloc]initWithFrame:CGRectMake(label2.x, label2.y+label2.height+8, 60, 13)];
    label3.text = @"揭晓时间:";
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    label3.textColor = YKYDeTitleColor;
    [back addSubview:label3];
    UILabel * joinTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label3.x+label3.width, label3.y, back.width-(label3.x+label3.width)-magin, 13)];
    if (!iPhone6plus) {
        joinTimeLabel.x = joinTimeLabel.x-5;
    }
    joinTimeLabel.text = joinTimeStr;
    joinTimeLabel.textAlignment = NSTextAlignmentLeft;
    joinTimeLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    joinTimeLabel.textColor = YKYDeTitleColor;
    [back addSubview:joinTimeLabel];

    //底部图
    UIView * bottomBackView = [[UIView alloc]initWithFrame:CGRectMake(0, back.height-30, back.width, 40)];
    bottomBackView.backgroundColor = YKYClearColor;
    [back addSubview:bottomBackView];
    //底部背景图
    UIImageView * bottomImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bottomBackView.width, bottomBackView.height)];
    bottomImgV.image = [UIImage imageNamed:@"jiexiaoLuckBottonImg"];
    [bottomBackView addSubview:bottomImgV];
    //幸运摇码label
    UILabel * label4= [[UILabel alloc]initWithFrame:CGRectMake(magin, 0.5*(bottomBackView.height-13), 80, 13)];
    label4.text = @"幸运摇购码:";
    label4.textAlignment = NSTextAlignmentLeft;
    label4.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    label4.textColor = [UIColor whiteColor];
    [bottomBackView addSubview:label4];
    UILabel * luckNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(label4.x+label4.width, label4.y, bottomBackView.width-(label4.x+label4.width)-magin-64, 13)];
    luckNumLabel.text = luckNumStr;
    luckNumLabel.textAlignment = NSTextAlignmentLeft;
    luckNumLabel.font = [UIFont boldSystemFontOfSize:[myFont getTitle4]];
    luckNumLabel.textColor = [UIColor whiteColor];
    [bottomBackView addSubview:luckNumLabel];
    //计算详情btn
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(bottomBackView.width-64-magin, luckNumLabel.y-2, 64, 18)];
    [btn setBackgroundImage:[UIImage imageNamed:@"计算详情button"] forState:UIControlStateNormal];
    [btn addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:btn];


    return back;
}

@end
