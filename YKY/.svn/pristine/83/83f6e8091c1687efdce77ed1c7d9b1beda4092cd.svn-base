//
//  newActivityDetailModel.m
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newActivityDetailModel.h"

@implementation newActivityDetailModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    newActivityDetailModel *activityDetailInfo = [[newActivityDetailModel alloc]init];
    
    activityDetailInfo.pname = dict[@"pname"];
    activityDetailInfo.experiedTime = dict[@"experiedTime"];
    activityDetailInfo.pamount = [NSString stringWithFormat:@"%@",dict[@"pamount"]];
    activityDetailInfo.url = dict[@"url"];
    activityDetailInfo.pnowamount = [NSString stringWithFormat:@"%@",dict[@"pnowamount"]];
    activityDetailInfo.pid = [NSString stringWithFormat:@"%@",dict[@"pid"]];
    activityDetailInfo.jpId = [NSString stringWithFormat:@"%@",dict[@"jpId"]];

    return activityDetailInfo;

}

@end
