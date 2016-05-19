//
//  homeMidView.m
//  YKY
//
//  Created by 肖 亮 on 15/12/31.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
/********************添加首页中部四哥模块*********************/
//

#import "homeMidView.h"
#import "UIView+XL.h"
#import "homeVC.h"

@implementation homeMidView


+(void)addMidViewWithY:(CGFloat)Y andViewController:(homeVC *)VC andActiviAction:(SEL)actiAciton andzhongjiagnAction:(SEL)zhongAction andTaoAction:(SEL)taoAction andYaoAction:(SEL)YaoAction{

    //1、背景View
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, VC.view.width, 160)];
    backView.backgroundColor = [UIColor whiteColor];
    [VC.backScrollerView addSubview:backView];
    //顶线
    [self addLineWithFrame:CGRectMake(0, 0, kScreenWidth, 1) andBackView:backView];
    //底线
    [self addLineWithFrame:CGRectMake(0, backView.height-1, backView.width, 1) andBackView:backView];


    //2、活动专区
    CGFloat actiIMGW = 101;
    CGFloat actiIMGH = 71;
    CGFloat actiW = 0.4*VC.view.width;
    CGFloat magin = 15;
    UIView * actiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, actiW, backView.height)];
    actiView.backgroundColor = [UIColor clearColor];
    [backView addSubview:actiView];
    //长竖线
    [line addLineWithFrame:CGRectMake(actiView.width+10, 0, 1, actiView.height) andBackView:backView];
    //添加内容
    if (VC.view.height>668) {//适配6p和6sp
        [self addDataWithTitle:@"活动专区" andFrame:CGRectMake(magin, magin+6, actiW-2*magin, 20) deTitle:@"火热活动正在进行" andDeTitleFrame:CGRectMake(magin,magin+30,actiView.width-2*magin,15) andimgFrame:CGRectMake(magin, magin+17+0.4*magin+30, 101, 76) andImgName:@"活动专区" ToView:actiView VC:VC andAction:actiAciton];
    }else{//5/5s/6/6s
        [self addDataWithTitle:@"活动专区" andFrame:CGRectMake(magin, magin+6, actiW-2*magin, 18) deTitle:@"火热活动正在进行" andDeTitleFrame:CGRectMake(magin,magin+25,actiView.width-2*magin,15) andimgFrame:CGRectMake(magin, magin+17+0.4*magin+40, actiW-2*(magin+10), (actiW-2*(magin+10))*actiIMGH/actiIMGW) andImgName:@"活动专区" ToView:actiView VC:VC andAction:actiAciton];
    }


    //3、最新揭晓
    UIView * zxjxView = [[UIView alloc]initWithFrame:CGRectMake(actiView.width+10, 0, VC.view.width-actiView.width, 0.5*actiView.height)];
    zxjxView.backgroundColor = [UIColor clearColor];
    [backView addSubview:zxjxView];
    //中横线
    [line addLineWithFrame:CGRectMake(actiView.width+10, 0.5*actiView.height, zxjxView.width, 1) andBackView:backView];
    if (VC.view.height>668) {//适配6p和6sp
        [self addDataWithTitle:@"最新揭晓" andFrame:CGRectMake(magin, magin+6, actiW-2*magin, 20) deTitle:@"每分每秒都有惊喜" andDeTitleFrame:CGRectMake(magin,magin+30,zxjxView.width-76-magin,15) andimgFrame:CGRectMake(zxjxView.width-2*magin-72, 1.25*magin, 72, 42) andImgName:@"最新揭晓" ToView:zxjxView VC:VC andAction:taoAction];
    }else{//5/5s/6/6s
        [self addDataWithTitle:@"最新揭晓" andFrame:CGRectMake(magin, magin+6, actiW-2*magin, 16) deTitle:@"每分每秒都有惊喜" andDeTitleFrame:CGRectMake(magin,magin+25,zxjxView.width-76-magin,15) andimgFrame:CGRectMake(zxjxView.width-2*magin-43, 1.5*magin, 43, 40) andImgName:@"最新揭晓" ToView:zxjxView VC:VC andAction:taoAction];
    }

    //4、中奖名单
    UIView * zhongView = [[UIView alloc]initWithFrame:CGRectMake(actiView.width+10, 0.5*actiView.height, VC.view.width-actiView.width, 0.5*actiView.height)];
    zhongView.backgroundColor = [UIColor clearColor];
    [backView addSubview:zhongView];
    if (VC.view.height>668) {//适配6p和6sp
        [self addDataWithTitle:@"中奖摇粉" andFrame:CGRectMake(magin, magin+6, actiW-2*magin, 20) deTitle:@"快来围观幸运儿" andDeTitleFrame:CGRectMake(magin,magin+30,zxjxView.width-86-magin,15) andimgFrame:CGRectMake(zhongView.width-2*magin-60, magin, 50, 53) andImgName:@"头奖摇粉" ToView:zhongView VC:VC andAction:zhongAction];
    }else{//5/5s/6/6s
        [self addDataWithTitle:@"中奖摇粉" andFrame:CGRectMake(magin, magin+6, actiW-2*magin, 16) deTitle:@"快来围观幸运儿" andDeTitleFrame:CGRectMake(magin,magin+25,zxjxView.width-86-magin,15) andimgFrame:CGRectMake(zhongView.width-2*magin-40, 1.25*magin, 40, 43) andImgName:@"头奖摇粉" ToView:zhongView VC:VC andAction:zhongAction];
    }




//    //4.淘购
//    UIView * taoView = [[UIView alloc]initWithFrame:CGRectMake(actiView.width, zhongView.height, 0.5*zhongView.width, zhongView.height)];
//    taoView.backgroundColor = [UIColor clearColor];
//    [backView addSubview:taoView];
//    //短竖线
//    [self addLineWithFrame:CGRectMake(actiView.width+taoView.width-1, taoView.y, 1, taoView.height) andBackView:backView];
//    if (VC.view.height>668) {//适配6p和6sp
//        [self addDataWithTitle:@"摇 购" andFrame:CGRectMake(0.5*(taoView.width-50), magin+1, 50, 14) deTitle:@"摇的就是心跳" andDeTitleFrame:CGRectMake(magin, magin+22, taoView.width-2*magin, 13) andimgFrame:CGRectMake(0.5*(taoView.width-34), 2*magin+32, 30, 27) andImgName:@"rock" ToView:taoView VC:VC andAction:taoAction];
//    }else{//5/5s/6/6s
//        [self addDataWithTitle:@"摇 购" andFrame:CGRectMake(0.5*(taoView.width-50), magin-3, 50, 14) deTitle:@"摇的就是心跳" andDeTitleFrame:CGRectMake(magin, magin+18, taoView.width-2*magin, 13) andimgFrame:CGRectMake(0.5*(taoView.width-34), 2*magin+30, 30, 27) andImgName:@"rock" ToView:taoView VC:VC andAction:taoAction];
//    }
//
//
//    //5.摇购
//    UIView * yaoView = [[UIView alloc]initWithFrame:CGRectMake(taoView.x+taoView.width, taoView.y, taoView.width, taoView.height)];
//    yaoView.backgroundColor = [UIColor clearColor];
//    [backView addSubview:yaoView];
//    if (VC.view.height>668) {//适配6p和6sp
//        [self addDataWithTitle:@"淘 购" andFrame:CGRectMake(0.5*(taoView.width-50), magin+1, 50, 14) deTitle:@"淘便宜 伐开心" andDeTitleFrame:CGRectMake(magin, magin+22, taoView.width-2*magin, 13) andimgFrame:CGRectMake(0.5*(taoView.width-34), 2*magin+32, 28, 28) andImgName:@"tao" ToView:yaoView VC:VC andAction:YaoAction];
//    }else{//5/5s/6/6s
//        [self addDataWithTitle:@"淘 购" andFrame:CGRectMake(0.5*(taoView.width-50), magin-3, 50, 14) deTitle:@"淘便宜 伐开心" andDeTitleFrame:CGRectMake(magin, magin+18, taoView.width-2*magin, 13) andimgFrame:CGRectMake(0.5*(taoView.width-34), 2*magin+30, 28, 28) andImgName:@"tao" ToView:yaoView VC:VC andAction:YaoAction];
//    }
}


#pragma mark - 添加中间的间隔线
+(void)addLineWithFrame:(CGRect)frame andBackView:(UIView *)backView {
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = YKYColor(216, 216, 216);
    [backView addSubview:line];
}

#pragma mark - 添加具体内容
+(void)addDataWithTitle:(NSString *)title andFrame:(CGRect)titFrame deTitle:(NSString *)deTitle andDeTitleFrame:(CGRect)deFrame andimgFrame:(CGRect)imgFrame andImgName:(NSString *)imgName ToView:(UIView *)View VC:(homeVC*)VC andAction:(SEL)action {

    //title
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:titFrame];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:[myFont getTitle1]];
    titleLabel.textColor = YKYColor(254, 64, 60);
    if ([title isEqualToString:@"最新揭晓"]) {
        titleLabel.textColor = YKYColor(254, 119, 60);
    }else if ([title isEqualToString:@"中奖摇粉"]){
        titleLabel.textColor = YKYColor(60, 183, 254);
    }
    [View addSubview:titleLabel];


    //detitle
    UILabel * deTitleLabel = [[UILabel alloc]initWithFrame:deFrame];
    deTitleLabel.text = deTitle;
    deTitleLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    deTitleLabel.textColor = [UIColor lightGrayColor];
    [View addSubview:deTitleLabel];

    if (VC.view.height>668) {
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        deTitleLabel.font = [UIFont systemFontOfSize:13];
    }

    if ([title isEqualToString:@"淘 购"] || [title isEqualToString:@"摇 购"]) {
        titleLabel.textAlignment = NSTextAlignmentCenter;
        deTitleLabel.textAlignment = NSTextAlignmentCenter;
    }

    //imgView
    UIImageView * imgview = [[UIImageView alloc]initWithFrame:imgFrame];
    imgview.backgroundColor = [UIColor clearColor];
    imgview.image = [UIImage imageNamed:imgName];
    [View addSubview:imgview];

    //btn
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, View.width, View.height)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    [View addSubview:btn];

}




@end
