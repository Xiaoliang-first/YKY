//
//  unUsedPrizeModel.m
//  YKY
//
//  Created by 亮肖 on 15/5/6.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "unUsedPrizeModel.h"

@implementation unUsedPrizeModel


+ (instancetype)prizeWithDict:(NSDictionary *)dict{
    
    unUsedPrizeModel * prizeInfo = [[unUsedPrizeModel alloc]init];
    
    prizeInfo.pname = dict[@"pname"];
    prizeInfo.url = dict[@"url"];
    prizeInfo.mname = dict[@"mname"];
    prizeInfo.etime = [NSString stringWithFormat:@"%@",dict[@"etime"]];
    prizeInfo.cid = [NSString stringWithFormat:@"%@",dict[@"cid"]];
    prizeInfo.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    prizeInfo.couponsCode = [NSString stringWithFormat:@"%@",dict[@"couponsCode"]];

    return prizeInfo;
}

@end
