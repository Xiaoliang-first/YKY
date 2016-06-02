//
//  bossLookConsumeListModel.m
//  YKY
//
//  Created by 肖亮 on 15/7/2.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "bossLookConsumeListModel.h"

@implementation bossLookConsumeListModel

+ (instancetype)usedPrizeWithDict:(NSDictionary *)dict{
    
    bossLookConsumeListModel * prizeInfo = [[bossLookConsumeListModel alloc]init];
    
    prizeInfo.name = dict[@"pname"];
    prizeInfo.phone = dict[@"phone"];
    prizeInfo.code = dict[@"code"];
    prizeInfo.time = dict[@"time"];

    
    return prizeInfo;
}

@end
