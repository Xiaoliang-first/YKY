//
//  luckView.m
//  YKY
//
//  Created by 肖 亮 on 16/5/1.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "luckView.h"

@implementation luckView

-(void)showWithModel:(id)model VC:(UIViewController*)VC Action:(SEL)action serials:(NSString*)serials pname:(NSString*)pname{

    self.backgroundColor = YKYClearColor;

    UIImageView * backImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    backImgV.image = [UIImage imageNamed:@"恭喜你"];
    [self addSubview:backImgV];

    UILabel * serialsL = [[UILabel alloc]initWithFrame:CGRectMake(0, backImgV.centerY-30, backImgV.width, 20)];
    serialsL.text = [NSString stringWithFormat:@"在第%@期",serials];
    serialsL.textColor = YKYTitleColor;
    serialsL.textAlignment = NSTextAlignmentCenter;
    serialsL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self addSubview:serialsL];

    UILabel * la2 = [[UILabel alloc]initWithFrame:CGRectMake(0, backImgV.centerY-10,backImgV.width, 20)];
    la2.textColor = YKYTitleColor;
    la2.textAlignment = NSTextAlignmentCenter;
    la2.text = @"参加一块摇摇购";
    la2.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self addSubview:la2];

    UILabel * la3 = [[UILabel alloc]initWithFrame:CGRectMake(0, backImgV.centerY+10,backImgV.width, 20)];
    la3.textColor = YKYTitleColor;
    la3.textAlignment = NSTextAlignmentCenter;
    la3.text = [NSString stringWithFormat:@"活动喜中\"%@\"",pname];
    la3.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self addSubview:la3];

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(backImgV.centerX-31, backImgV.height-22-30, 62, 25)];
    [btn setBackgroundImage:[UIImage imageNamed:@"点击查看button"] forState:UIControlStateNormal];

    [btn addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}



@end
