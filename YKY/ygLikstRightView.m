//
//  ygLikstRightView.m
//  YKY
//
//  Created by 肖 亮 on 16/4/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "ygLikstRightView.h"
#import "btnsModel.h"

@implementation ygLikstRightView

+(void)addRightViewWithArray:(NSArray*)array view:(UIView*)view frame:(CGRect)frame VC:(UIViewController*)vc action:(SEL)action{
    UIView * myview = [[UIView alloc]initWithFrame:frame];
    myview.backgroundColor = [UIColor whiteColor];
    [view addSubview:myview];
    for (NSInteger i = 0; i < array.count; i++) {
        btnsModel * model = array[i];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5*i*frame.size.height, frame.size.width, 0.5*frame.size.height)];
        [btn setTitle:model.title forState:UIControlStateNormal];
        btn.tag = 2234+i;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
        [myview addSubview:btn];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5*(i+1)*frame.size.height, frame.size.width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [myview addSubview:line];
    }
}

@end
