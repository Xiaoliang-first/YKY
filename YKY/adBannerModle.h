//
//  adBannerModle.h
//  YKY
//
//  Created by 肖 亮 on 16/3/4.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface adBannerModle : NSObject

/** banner广告id */
@property (nonatomic , copy) NSString * ID;
/** banner广告图片地址url */
@property (nonatomic , copy) NSString * apic;
/** banner广告图片详情url */
@property (nonatomic , copy) NSString * aurl;


+(instancetype)adModelWithDict:(NSDictionary *)dict;

@end
