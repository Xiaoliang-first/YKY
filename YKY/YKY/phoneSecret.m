//
//  phoneSecret.m
//  YKY
//
//  Created by 肖 亮 on 16/4/21.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "phoneSecret.h"

@implementation phoneSecret
+(NSString*)phoneSecretWithPhoneNum:(NSString *)phone{

    NSString * str1 = [phone substringToIndex:3];
    NSString * str2 = [phone substringFromIndex:7];
    NSString * str3 = [str1 stringByAppendingString:@"****"];
    NSString * str = [str3 stringByAppendingString:str2];
    DebugLog(@"str1%@---str2%@---%@str3---str%@",str1,str2,str3,str);
    return str;
}
@end
