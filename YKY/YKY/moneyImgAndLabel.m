//
//  moneyImgAndLabel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/15.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "moneyImgAndLabel.h"

@implementation moneyImgAndLabel

+(UILabel*)addjinyinImagAndlabelBackViewWithFrame:(CGRect)frame ImgName:(NSString*)imgName imgW:(CGFloat)glImgvW imgH:(CGFloat)glImgvH backView:(UIView *)backView{

    CGFloat glNlW = frame.size.width/2+4;

    UIView * back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = [UIColor clearColor];
    [backView addSubview:back];
    //图
    UIImageView * siImgV = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width/2-glImgvW-4), 0.5*(back.height-glImgvH), glImgvW, glImgvH)];
    siImgV.image = [UIImage imageNamed:imgName];
    [back addSubview:siImgV];
    //数
    UILabel * siL = [[UILabel alloc]initWithFrame:CGRectMake(siImgV.x+siImgV.width+8, siImgV.y, glNlW, glImgvH)];
    siL.font = [UIFont systemFontOfSize:13];
    siL.textColor = [UIColor darkGrayColor];
    [back addSubview:siL];

    return siL;
}

+(UILabel*)SHUaddjinyinImagAndlabelBackViewWithFrame:(CGRect)frame ImgName:(NSString*)imgName imgW:(CGFloat)glImgvW imgH:(CGFloat)glImgvH backView:(UIView *)backView titleColor:(UIColor*)color{
    CGFloat glNlW = frame.size.width/2+4;

    UIView * back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = [UIColor clearColor];
    [backView addSubview:back];
    //图
    UIImageView * siImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(back.width-glImgvW), 0.5*(back.height-glImgvH), glImgvW, glImgvH)];
    siImgV.image = [UIImage imageNamed:imgName];
    [back addSubview:siImgV];
    //数
    UILabel * siL = [[UILabel alloc]initWithFrame:CGRectMake(0.5*(back.width-glNlW), siImgV.y+siImgV.height+8, glNlW, glImgvH)];
    siL.font = [UIFont systemFontOfSize:13];
    siL.textColor = color;
    siL.textAlignment = NSTextAlignmentCenter;
    [back addSubview:siL];

    return siL;
}


@end
