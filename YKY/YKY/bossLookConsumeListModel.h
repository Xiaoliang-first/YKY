//
//  bossLookConsumeListModel.h
//  YKY
//
//  Created by 肖亮 on 15/7/2.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bossLookConsumeListModel : NSObject


/** 消费商品的名字 */
@property (nonatomic , copy) NSString * name;
/** 消费商品的兑换码 */
@property (nonatomic , copy) NSString * code;

/** 消费者的phone */
@property (nonatomic , copy) NSString * phone;

/** 兑换时间time */
@property (nonatomic , copy) NSString * time;




+ (instancetype)usedPrizeWithDict:(NSDictionary *)dict;

@end
