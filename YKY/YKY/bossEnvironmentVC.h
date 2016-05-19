//
//  bossEnvironmentVC.h
//  YKY
//
//  Created by 亮肖 on 15/6/11.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class prizeDetailModel;
@interface bossEnvironmentVC : UIViewController

/** 接收到的奖品数据模型 */
@property (nonatomic , strong) prizeDetailModel * prizeDetailModel;
/** 判断标示（判断是谁push进来的，1标示是主界面 2标示是活动专区） */
//@property (nonatomic , copy) NSString * indentify;


@end
