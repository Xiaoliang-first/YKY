//
//  addLuckNumView.m
//  YKY
//
//  Created by 肖 亮 on 16/4/23.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "addLuckNumView.h"


#define kmagin 15.0

static UIButton * btn;
static UIView * smallView;
static UIButton * xiaX;

@implementation addLuckNumView


+(void)addSmallViewWithModel:(NSArray*)array VC:(UIViewController*)VC toView:(UIView*)view{
    DebugLog(@"查看摇码");

    btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.6;
    [btn addTarget:self action:@selector(dissmass) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    //
    //
    CGFloat smallvH = 0.5*kScreenheight;
    smallView = [[UIView alloc]initWithFrame:CGRectMake(2*kmagin, 0.5*(kScreenheight-smallvH), kScreenWidth-4*kmagin, smallvH)];
    smallView.backgroundColor = [UIColor whiteColor];
    [view addSubview:smallView];
    //设置图片圆角
    smallView.layer.cornerRadius = 5;
    smallView.layer.masksToBounds = YES;
    smallView.layer.borderWidth = 0.01;


    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, smallView.width, 35)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"我的摇码"];
    titleLabel.textColor = YKYTitleColor;
    [smallView addSubview:titleLabel];
    [line addLineWithFrame:CGRectMake(0, 34, smallView.width, 1) andBackView:smallView];

    UIScrollView * backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 35, smallView.width, smallView.height-65)];
    backScrollView.contentSize = CGSizeMake(smallView.width, smallView.height-35);
    backScrollView.backgroundColor = YKYClearColor;
    [smallView addSubview:backScrollView];

    
    int clmit = 2;
    CGFloat magin = 8;
    CGFloat labelW = 0.5*(smallView.width-3*magin);
    CGFloat labelH = 30;

    for (int i = 0; i<array.count; i++) {
        CGFloat currentClmit = i%clmit;
        CGFloat currentLon = i/clmit;
        CGFloat IX = magin + currentClmit*(magin+labelW);
        CGFloat IY = magin + currentLon*(magin+labelH);

        NSString * string = [NSString string];
        string = [array objectAtIndex:i];
        long nums = [string intValue];
        NSString * str = [NSString stringWithFormat:@"%ld",nums];

        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(IX, IY, labelW, labelH)];
        labe.text = str;
        labe.textAlignment = NSTextAlignmentCenter;
        labe.textColor = YKYDeTitleColor;
        labe.font = [UIFont systemFontOfSize:15];

        [backScrollView addSubview:labe];

        backScrollView.contentSize = CGSizeMake(smallView.width, labe.y+labe.height+8);
    }

    xiaX = [[UIButton alloc]initWithFrame:CGRectMake(smallView.x+smallView.width-30, smallView.y-35, 30, 30)];
    [xiaX setBackgroundImage:[UIImage imageNamed:@"xiaochazi"] forState:UIControlStateNormal];
    [xiaX addTarget:self action:@selector(dissmass) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:xiaX];

}



+(void)dissmass{
    [btn removeFromSuperview];
    [xiaX removeFromSuperview];
    [smallView removeFromSuperview];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isDissMiss"];
}

@end
