//
//  managerCommendatoryModel.h
//  YKY
//
//  Created by 亮肖 on 15/6/16.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface managerCommendatoryModel : NSObject

/** 店长推荐时间 */
@property (nonatomic , copy) NSString * goodsDate;
/** 推荐奖品口味类型 */
@property (nonatomic , copy) NSString * goodsDesc;
/** 推荐奖品的名称 */
@property (nonatomic , copy) NSString * goodsName;
/** 推荐奖品的价格 */
@property (nonatomic , copy) NSString * goodsPrice;
/** 推荐奖品的图片URL字符串 */
@property (nonatomic , copy) NSString * goodsUrl;
/** 推荐奖品的商家ID */
@property (nonatomic , copy) NSString * supplierId;

+(instancetype)modelWithDict:(NSDictionary *)dict;


@end
