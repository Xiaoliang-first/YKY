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
/** 消费商品的总数 */
@property (nonatomic , copy) NSString * count;

+ (instancetype)usedPrizeWithDict:(NSDictionary *)dict;

@end
