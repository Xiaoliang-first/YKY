//
//  Account.h
//  HLQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 hyqy. All rights reserved.
//

/* 用户登陆成功时返回的参数
 
 phone = 13051516666,
 code = 0,
 gold = 926,
 msg = success,
 reponseToken = 1430207472509,
 uiId = 632,
 silverCoin = 9
 
 */

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>

/** 用户ID */
@property(nonatomic , copy)NSString *uiId;
/** 用户电话账户 */
@property(nonatomic , copy)NSString *phone;
/** gold为当前用户金币数量 */
@property(nonatomic , copy) NSString *gold;
/** silverCoin为当前用户银币数量 */
@property(nonatomic , copy)NSString *silverCoin;
/** 钻石数 */
@property (nonatomic , copy) NSString * diamonds;
/** 用户的token（用于单点登录） */
@property (nonatomic , copy) NSString * reponseToken ;

+(instancetype)accountWithDict:(NSDictionary *)dict;

@end


