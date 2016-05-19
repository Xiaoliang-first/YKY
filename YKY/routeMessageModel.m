//
//  routeMessageModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/26.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "routeMessageModel.h"

@implementation routeMessageModel

+(instancetype)modelWithDict:(NSDictionary *)dict{

    routeMessageModel * model = [[routeMessageModel alloc]init];

    model.lname = [NSString stringWithFormat:@"%@",dict[@"lname"]];
    model.lnumber = [NSString stringWithFormat:@"%@",dict[@"lnumber"]];
    model.raddress = [NSString stringWithFormat:@"%@",dict[@"raddress"]];
    model.rname = [NSString stringWithFormat:@"%@",dict[@"rname"]];
    model.rphone = [NSString stringWithFormat:@"%@",dict[@"rphone"]];
    if (dict[@"otime"]) {
        model.otime = [NSString stringWithFormat:@"%@",dict[@"otime"]];
    }
    if (dict[@"stime"]) {
        model.stime = [NSString stringWithFormat:@"%@",dict[@"stime"]];
    }
    if (dict[@"stime"]) {
        model.rtime = [NSString stringWithFormat:@"%@",dict[@"rtime"]];
    }



    return model;
}

@end
