//
//  homeNewScuessDetailVC.h
//  YKY
//
//  Created by 肖 亮 on 16/4/21.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@class homeNewScuessModel;
@interface homeNewScuessDetailVC : UIViewController

@property (nonatomic , strong) homeNewScuessModel * prizemodel;

@property (nonatomic , copy) NSString * serialID;

@property (nonatomic , copy) NSString * pid;

@end
