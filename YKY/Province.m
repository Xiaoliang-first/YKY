//
//  Province.m
//  03-城市选择
//
//  Created by Romeo on 15/7/18.
//  Copyright (c) 2016年 . All rights reserved.
//

#import "Province.h"

@implementation Province

+ (instancetype)provinceWithDict:(NSDictionary*)dict
{
    Province* pro = [[self alloc] init];
    [pro setValuesForKeysWithDictionary:dict];
    return pro;
}

@end
