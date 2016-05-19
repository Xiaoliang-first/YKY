//
//  cityModel.h
//  YKY
//
//  Created by 亮肖 on 15/4/30.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cityModel : NSObject

/**  city的Name */
@property (nonatomic , copy) NSString * ciName;
/**  city分组的ID */
@property (nonatomic , copy) NSString * ciId;
/**  city的字母简称 */
@property (nonatomic , copy) NSString * cityOrder;
/**  city的代理商id */
@property (nonatomic , copy) NSString * agentId;

+ (instancetype)cityWithDict:(NSDictionary *)dict;

@end
