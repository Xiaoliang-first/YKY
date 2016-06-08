//
//  rockingPrizeData.m
//  YKY
//
//  Created by 肖亮 on 15/12/17.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "rockingPrizeData.h"
#import "UIView+XL.h"
#import "UIImageView+WebCache.h"
#import "common.h"


static UIButton * btn;
static UIView * view1;
static UIButton * cancelBtn;


@implementation rockingPrizeData


+(void)prizeShowWithCouponsName:(NSString *)couponsName andImgUrlStr:(NSString *)url andEndDate:(NSString *)endDate andVC:(UIViewController *)VC remove:(SEL)remove lookDetail:(SEL)lookDetail share:(SEL)share{
    //1.0大背景Btn
    btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor blackColor];
    btn.frame = CGRectMake(0, 0, kScreenWidth,kScreenheight);
    btn.alpha = kalpha;
    [btn addTarget:VC action:remove forControlEvents:UIControlEventTouchUpInside];
    [VC.view addSubview:btn];
    
    //2.0提示背景View
    CGFloat x = 30;
    CGFloat y = VC.view.centerY-(VC.view.width-50)/2;
    CGFloat w = VC.view.width-60;
    CGFloat h = VC.view.width-55;
    view1 = [[UIView alloc]init];
    view1.backgroundColor = YKYColor(255, 86, 83);
    view1.frame = CGRectMake(x,y,w,h);
    [VC.view insertSubview:view1 aboveSubview:btn];

    //设置图片圆角
    view1.layer.cornerRadius = 5;
    view1.layer.masksToBounds = YES;
    view1.layer.borderWidth = 0.01;

    
    //2.1奖品名字Label
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, w, h/8)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:17];
    if (VC.view.height > 668) {
        nameLabel.font = [UIFont systemFontOfSize:18];
    }
    nameLabel.text = couponsName;
    [view1 addSubview:nameLabel];
    
    //2.2小Btn
    cancelBtn = [[UIButton alloc]init];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"xiaochazi"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(w+x-12, y-28 , 24, 24);
    [cancelBtn addTarget:VC action:remove forControlEvents:UIControlEventTouchUpInside];
    [VC.view addSubview:cancelBtn];
    
    
    //2.3奖品背景View
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, nameLabel.y+nameLabel.height, view1.width, view1.height-(nameLabel.y+nameLabel.height))];
    view2.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:view2];
    
    
    //2.4奖品图片
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    imgView.frame = CGRectMake(8, 8, view1.width-16, 3.5*nameLabel.height);
    [view2 addSubview:imgView];
    
    
    //2.5奖品有效期
    UILabel * label = [[UILabel alloc]init];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"请于%@前使用",endDate];
    label.frame = CGRectMake(0, imgView.y+imgView.height+3, view1.width, 20);
    label.font = [UIFont systemFontOfSize:15];
    if (VC.view.height > 668) {
        label.frame = CGRectMake(0, imgView.y+imgView.height+8, view1.width, 30);
        
        label.font = [UIFont systemFontOfSize:20];
    }
    [view2 addSubview:label];
    
    
    //2.6查看详情按钮
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(imgView.x-20, label.y+label.height+8, imgView.width+50, 20)];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    if (VC.view.height > 668) {
        btn2.frame = CGRectMake(imgView.x-20, label.y+label.height+3, imgView.width+50, 30);
        btn2.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    [btn2 setTitle:@"【点击查看详情】" forState:UIControlStateNormal];
    [btn2 setTitleColor:YKYColor(31, 167, 166) forState:UIControlStateNormal];
    [view2 addSubview:btn2];
    [btn2 addTarget:VC action:lookDetail forControlEvents:UIControlEventTouchUpInside];
    
    
    //2.7与好友分享按钮
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(10, view2.height-43, view1.width-20, 35)];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"chengseyuanjiaojuxing"] forState:UIControlStateNormal];
    [btn3 setTitle:@"与好友分享" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view2 addSubview:btn3];
    [btn3 addTarget:VC action:share forControlEvents:UIControlEventTouchUpInside];
}


+(void)dissmess{
    [btn removeFromSuperview];
    [cancelBtn removeFromSuperview];
    [view1 removeFromSuperview];
}


@end
