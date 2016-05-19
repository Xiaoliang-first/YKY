//
//  myGold.h
//  YKY
//
//  Created by 肖 亮 on 16/5/1.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myGold : NSObject


@property (nonatomic , copy) NSString * pname;
@property (nonatomic , copy) NSString * serials;

+(instancetype)modelWithDict:(NSDictionary*)dict;

@end
