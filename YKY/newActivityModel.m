//
//  newActivityModel.m
//  YKY
//
//  Created by 肖亮 on 15/9/16.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newActivityModel.h"

@implementation newActivityModel


+(instancetype)modelWithDict:(NSDictionary *)dict{
    newActivityModel * model = [[newActivityModel alloc]init];
    
    model.activeId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    model.mid = [NSString stringWithFormat:@"%@",dict[@"mid"]];
    model.activeName = dict[@"aname"];
    model.activeUrl = dict[@"apic"];
    model.aintro = dict[@"aintro"];
    model.startDate = dict[@"startTime"];
    model.endDate = dict[@"endTime"];
    model.statu = dict[@"statu"];
    
    
    return model;
}


@end
