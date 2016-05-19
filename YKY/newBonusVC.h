//
//  newBonusVC.h
//  YKY
//
//  Created by 肖亮 on 15/9/6.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class unUsedPrizeModel;


@interface newBonusVC : UIViewController

@property (nonatomic) BOOL isActivityRockPrize;

//从详情界面返回时，记录详情所在界面
@property (nonatomic , copy) NSString * prizetype;
@property (nonatomic , strong) unUsedPrizeModel * backPrizeModel;
////点击使用按钮从cell传过来的Model
//@property (nonatomic , strong) unUsedPrizeModel * useModel;
@property (nonatomic ) int location;

@property (nonatomic , copy) NSString * titleStr;

-(void)updataPrize;

@end
