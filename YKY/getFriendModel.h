//
//  getFriendModel.h
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getFriendModel : NSObject

@property (nonatomic , copy) NSString * phone;
@property (nonatomic , copy) NSString * signTime;
@property (nonatomic , copy) NSString * diamondsNum;
/** 1:钻石 2：金币 3：银币 */
@property (nonatomic , copy) NSString * type;

+(instancetype)modelWithDict:(NSDictionary*)dict;

@end
