//
//  rechargeModel.m
//  YKY
//
//  Created by 亮肖 on 15/5/21.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "rechargeModel.h"

@implementation rechargeModel

+(instancetype)rechargeWithDict:(NSDictionary *)dict{
    
    rechargeModel *model = [[rechargeModel alloc]init];
    model.orderNum = dict[@"order"];
    model.money = [NSString stringWithFormat:@"%@",dict[@"amount"]];
//    model.rechargeWay = dict[@"rechargeWay"];
    model.rechargeWay = [NSString stringWithFormat:@"%@",dict[@"ptype"]];
    model.makeTime = dict[@"otime"];
    
    return model;
}

@end
