//
//  aliterViewTool.m
//  YKY
//
//  Created by 亮肖 on 15/5/22.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "aliterViewTool.h"


@interface aliterViewTool ()

@end

@implementation aliterViewTool

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showWithRootView:(UIView*)view Text:(NSString *)text{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenheight)];
    backView.backgroundColor = [UIColor clearColor];
    
    self.backView = backView;
    
    [view addSubview:backView];
    //label设置
    UILabel * label = [[UILabel alloc]init];
    CGFloat W = 160.0;
    label.frame = CGRectMake((kScreenWidth-W)/2, kScreenheight - 2*W, W, 35);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor darkGrayColor];
    label.text = text;
    label.font = [UIFont systemFontOfSize:11];
    //label圆角设置
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 0.1;
    
    [backView addSubview:label];
}

+ (void)stopWithTime:(CGFloat)time{
    //延时执行消失Label
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(labelDiss) userInfo:nil repeats:NO];
}

- (void)labelDiss{
    [self.backView removeFromSuperview];
}


@end
