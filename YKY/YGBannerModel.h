//
//  YGBannerModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/20.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGBannerModel : NSObject

@property (nonatomic , copy) NSString * ID;
@property (nonatomic , copy) NSString * banner;


+(instancetype)modelWithDict:(NSDictionary*)dict;

@end
