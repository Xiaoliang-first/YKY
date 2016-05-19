//
//  YGRockModel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/23.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGRockModel : NSObject

@property (nonatomic , copy) NSString * restNum;
@property (nonatomic , copy) NSString * diamonds;
@property (nonatomic , strong) NSArray * uno;


+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
