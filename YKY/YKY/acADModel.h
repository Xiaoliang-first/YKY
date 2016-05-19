//
//  acADModel.h
//  YKY
//
//  Created by 亮肖 on 15/5/30.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface acADModel : NSObject

/** 活动id */
@property (nonatomic , copy) NSString * acid;
/**  活动广告图片的URL */
@property (nonatomic , copy) NSString * apic;
/** 广告链接 */
@property (nonatomic , copy) NSString * aurl;
/** 活动名称 */
@property (nonatomic , copy) NSString * aname;



+(instancetype)adWithDict:(NSDictionary *)dict;

@end
