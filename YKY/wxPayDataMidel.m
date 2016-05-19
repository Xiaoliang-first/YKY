//
//  wxPayDataMidel.m
//  YKY
//
//  Created by 肖 亮 on 16/3/17.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "wxPayDataMidel.h"

@implementation wxPayDataMidel

+(instancetype)modelWithDict:(NSDictionary*)dict{
    wxPayDataMidel * model = [[wxPayDataMidel alloc]init];
    model.retcode = [NSString stringWithFormat:@"%@",dict[@"retcode"]];
    model.partnerid = [NSString stringWithFormat:@"%@",dict[@"partnerid"]];
    model.timestamp = [NSString stringWithFormat:@"%@",dict[@"timestamp"]];
    model.retmsg = [NSString stringWithFormat:@"%@",dict[@"retmsg"]];
    model.package = dict[@"package"];
    model.noncestr = dict[@"noncestr"];
    model.sign = dict[@"sign"];
    model.appid = dict[@"appid"];
    model.prepayid = dict[@"prepayid"];

    return model;
}

@end
