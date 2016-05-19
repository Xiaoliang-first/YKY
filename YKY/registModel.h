//
//  registModel.h
//  YKY
//
//  Created by 肖亮 on 15/9/16.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface registModel : NSObject


@property (nonatomic , copy) NSString * couponsId;
@property (nonatomic , copy) NSString * prizeLowUrl;
/** 赠送的银币数 */
@property (nonatomic , copy) NSString * consuedCount;
@property (nonatomic , copy) NSString * type;


+(instancetype)registWithDict:(NSDictionary *)dict;

@end
