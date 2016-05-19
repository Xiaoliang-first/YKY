//
//  myCells.m
//  YKY
//
//  Created by 肖 亮 on 16/4/15.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "myCells.h"

@implementation myCells
+(UIView*)addCellsWithH:(CGFloat)h magin:(CGFloat)magin ImgvW:(CGFloat)shoujiW ImgH:(CGFloat)shoujiH backViewY:(CGFloat)viewY labelW:(CGFloat)labelW ImgName:(NSString *)imgName title:(NSString*)title ToView:(UIView*)mainView andClickAction:(SEL)action VC:(UIViewController*)VC{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, kScreenWidth, h)];
    view.backgroundColor = [UIColor clearColor];
    [mainView addSubview:view];
    //手机
    UIImageView * shouji = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-shoujiH), shoujiW, shoujiH)];
    shouji.image = [UIImage imageNamed:imgName];
    [view addSubview:shouji];
    //修改手机号Label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(shouji.x+shouji.width+10, 0.5*(h-shoujiH), labelW, shoujiH)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    [line addLineWithFrame:CGRectMake(label.x, h-1, kScreenWidth-label.x, 1) andBackView:view];
    //修改手机号Btn
    UIButton * fixBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, mainView.width, h)];
    fixBt.backgroundColor = [UIColor clearColor];
    [fixBt addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fixBt];
    return view;
}
@end
