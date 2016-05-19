//
//  NumberModel.h
//  YKY
//
//  Created by 肖亮 on 15/11/10.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberModel : NSObject

/** 奖品类型（0：本期大奖浏览统计  1：活动专区大奖浏览统计） */
@property (nonatomic , copy) NSString * type;
/** 奖品Id */
@property (nonatomic , copy) NSString * prizeId;
/** 浏览次数 */
@property (nonatomic) int clickNum;

+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
