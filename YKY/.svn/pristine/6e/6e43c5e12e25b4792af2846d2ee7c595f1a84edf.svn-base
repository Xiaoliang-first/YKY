//
//  userInfo.m
//  HLQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 hyqy. All rights reserved.
//

#import "userInfo.h"


@implementation userInfo

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    userInfo *info = [[userInfo alloc]init];
    info.uiName = dict[@"name"];
    info.uid = [NSString stringWithFormat:@"%@",dict[@"uid"]];
    info.age = [NSString stringWithFormat:@"%@",dict[@"age"]];
    info.uiHeadImage = dict[@"headImage"];
    info.uiGoldCoin = [NSString stringWithFormat:@"%@",dict[@"gold"]];
    info.uiSilverCoin = [NSString stringWithFormat:@"%@",dict[@"silver"]];
    info.hobby = dict[@"hobby"];
    info.uiSex = [NSString stringWithFormat:@"%@",dict[@"sex"]];
    info.diamonds = [NSString stringWithFormat:@"%@",dict[@"diamonds"]];
    
    return info;

}
@end
