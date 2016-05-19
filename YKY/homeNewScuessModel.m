//
//  homeNewScuessModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/20.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeNewScuessModel.h"

@implementation homeNewScuessModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    homeNewScuessModel * model = [[homeNewScuessModel alloc]init];
    model.uid = [NSString stringWithFormat:@"%@",dict[@"uid"]];
    model.joinCount = [NSString stringWithFormat:@"%@",dict[@"joinCount"]];
    model.luckCount = [NSString stringWithFormat:@"%@",dict[@"luckCount"]];
    model.uname = [NSString stringWithFormat:@"%@",dict[@"uname"]];
    model.headImage = [NSString stringWithFormat:@"%@",dict[@"headImage"]];
    model.pname = [NSString stringWithFormat:@"%@",dict[@"pname"]];
    model.pid = [NSString stringWithFormat:@"%@",dict[@"pid"]];
    model.serials = [NSString stringWithFormat:@"%@",dict[@"serials"]];
    if (dict[@"serialId"]) {
        model.serialId = [NSString stringWithFormat:@"%@",dict[@"serialId"]];
    }

    if (dict[@"ptime"]) {
        model.ptime = [NSString stringWithFormat:@"%@",dict[@"ptime"]];
    }

    if (dict[@"url"]) {
        model.url = [NSString stringWithFormat:@"%@",dict[@"url"]];
    }

    int num = [dict[@"luckCode"] intValue];
    model.priNum = [NSString stringWithFormat:@"%d",num+10000000];
    model.zongNum = [NSString stringWithFormat:@"%@",dict[@"price"]];
    model.shengNum = [NSString stringWithFormat:@"%@",dict[@"restNum"]];
    
    if (dict[@"plimit"]) {
        model.plimit = [NSString stringWithFormat:@"%@",dict[@"plimit"]];
    }
    model.perNum = [NSString stringWithFormat:@"%@",dict[@"perNum"]];
    int num2 = [dict[@"luckCode"] intValue];
    model.luckCode = [NSString stringWithFormat:@"%d",num2+10000000];
    model.time = [NSString stringWithFormat:@"%@",dict[@"time"]];
    model.orderStatue = @"-1";
    if (dict[@"orderStatue"]) {
        model.orderStatue = [NSString stringWithFormat:@"%@",dict[@"orderStatue"]];
    }
    if (dict[@"state"]) {
        model.state = [NSString stringWithFormat:@"%@",dict[@"state"]];
    }

    if (dict[@"orderId"]) {
        model.orderId = [NSString stringWithFormat:@"%@",dict[@"orderId"]];
    }

    if (dict[@"agentId"]) {
        model.agentId = [NSString stringWithFormat:@"%@",dict[@"agentId"]];
    }

    if (dict[@"otime"]) {
        model.otime = [NSString stringWithFormat:@"%@",dict[@"otime"]];
    }

    if (dict[@"stime"]) {
        model.stime = [NSString stringWithFormat:@"%@",dict[@"stime"]];
    }

    if (dict[@"rtime"]) {
        model.rtime = [NSString stringWithFormat:@"%@",dict[@"rtime"]];
    }


    return model;
}

-(void)setLuckCode:(NSString *)luckCode{
    _luckCode = luckCode;
}
-(void)setSerialId:(NSString *)serialId{
    _serialId = serialId;
}

@end
