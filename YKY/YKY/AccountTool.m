//
//  AccountTool.m
//  HLQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 hyqy. All rights reserved.
//

#import "AccountTool.h"
#import "Account.h"

#define AccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation AccountTool
+(void)saveAccount:(Account *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFile];
}
+(Account *)account
{
//取出账号
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFile];
    return account;
}
@end
