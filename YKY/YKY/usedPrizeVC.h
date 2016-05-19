//
//  usedPerzeVC.h
//  YKY
//
//  Created by 亮肖 on 15/5/6.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class unUsedPrizeModel,boundsPrizeDetailModel;
@interface usedPrizeVC : UIViewController

@property (nonatomic , strong) unUsedPrizeModel * prizeModel;
@property (nonatomic , strong) boundsPrizeDetailModel * bPDetailModel;

/** 判断是哪个地方push进来的，1：点击奖兜使用按钮  2：点击奖兜详情使用按钮 */
@property (nonatomic , copy) NSString * identafy;

@end
