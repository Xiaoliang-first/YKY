//
//  cityModel.m
//  YKY
//
//  Created by 亮肖 on 15/4/30.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "cityModel.h"

@implementation cityModel

+(instancetype)cityWithDict:(NSDictionary *)dict{
    cityModel *city = [[cityModel alloc]init];
    
    city.ciName = dict[@"ciName"];
    city.ciId = dict[@"ciId"];
    city.cityOrder = dict[@"cityOrder"];
    city.agentId = dict[@"aid"];

    return city;
}

@end
