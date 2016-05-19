//
//  boundsPrizeDetailModel.h
//  YKY
//
//  Created by 肖 亮 on 16/3/8.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface boundsPrizeDetailModel : NSObject

/** 商家名称 */
@property (nonatomic , copy) NSString * mname;
/** 奖品市场价格 */
@property (nonatomic , copy) NSString * marketPrice;
/** 奖品现在价格 */
@property (nonatomic , copy) NSString * price;
/** 商家地址 */
@property (nonatomic , copy) NSString * address;
/** 奖品使用说明 */
@property (nonatomic , copy) NSString * instructions;
/** 商家所在维度 */
@property (nonatomic , copy) NSString * lat;
/** 商家所在经度 */
@property (nonatomic , copy) NSString * lng;
/** 商家联系电话 */
@property (nonatomic , copy) NSString * servicePhone;
/** 商家id */
@property (nonatomic , copy) NSString * mid;
/** 奖品id */
@property (nonatomic , copy) NSString * pid;
/** 奖品名称 */
@property (nonatomic , copy) NSString * pname;
/** 奖品大图 */
@property (nonatomic , copy) NSString * url;
/** 奖品描述 */
@property (nonatomic , copy) NSString * introduction;
/** 奖品过期时间 */
@property (nonatomic , copy) NSString * etime;
/** 奖品兑换码 */
@property (nonatomic , copy) NSString * couponsCode;


+(instancetype)modelWithDict:(NSDictionary*)dic;

@end
