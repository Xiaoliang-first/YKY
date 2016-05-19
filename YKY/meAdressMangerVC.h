//
//  meAdressMangerVC.h
//  YKY
//
//  Created by 肖 亮 on 16/4/18.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface meAdressMangerVC : UIViewController

@property (nonatomic , copy) NSString * agentId;
@property (nonatomic , copy) NSString * serialId;

/** 判断是从哪个地方进的地址管理界面 1：状态跟踪进来的 0或者nil：账户管理进来的 */
@property (nonatomic , copy) NSString * identify;

@end
