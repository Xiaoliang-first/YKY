//
//  bossAccountTool.m
//  YKY
//
//  Created by 亮肖 on 15/5/19.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "bossAccountTool.h"
#import "bossAccount.h"


#define bossAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bossAccount.data"]

@implementation bossAccountTool

//需要存储的账号信息
+(void)saveAccount:(bossAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:bossAccountFile];
}
//返回要存储的账号信息
+(bossAccount *)account{
    //取出账号
    bossAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:bossAccountFile];
    return account;
}


@end
