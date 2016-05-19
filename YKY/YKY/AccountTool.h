//
//  AccountTool.h
//  HLQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 hyqy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Account;
@interface AccountTool : NSObject
//需要存储的账号信息
+(void)saveAccount:(Account *)account;
//返回要存储的账号信息
+(Account *)account;
@end
