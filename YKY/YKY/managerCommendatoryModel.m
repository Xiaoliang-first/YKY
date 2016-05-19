//
//  managerCommendatoryModel.m
//  YKY
//
//  Created by 亮肖 on 15/6/16.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "managerCommendatoryModel.h"

@implementation managerCommendatoryModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    managerCommendatoryModel *model = [[managerCommendatoryModel alloc]init];
    
    model.goodsDate = [NSString stringWithFormat:@"%@",dict[@"stime"]];
    model.goodsDesc = dict[@"sspecial"];
    model.goodsName = dict[@"sname"];
    model.goodsPrice = [NSString stringWithFormat:@"%@",dict[@"sprice"]];
    model.goodsUrl = dict[@"surl"];
    model.supplierId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    
    return model;
}


@end
