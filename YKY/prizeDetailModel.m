//
//  prizeDetailModel.m
//  YKY
//
//  Created by 肖 亮 on 16/3/5.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "prizeDetailModel.h"
#import "common.h"

@implementation prizeDetailModel


+(instancetype)modelWithDict:(NSDictionary *)dic{
    prizeDetailModel * model = [[prizeDetailModel alloc]init];
    model.mname = dic[@"mname"];
    model.marketPrice = [NSString stringWithFormat:@"%@",dic[@"marketPrice"]];
//    model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
    model.address = dic[@"address"];
    model.pintroduction = dic[@"pintroduction"];
    model.pname = dic[@"pname"];
    model.lng = [NSString stringWithFormat:@"%@",dic[@"lng"]];
    model.lat = [NSString stringWithFormat:@"%@",dic[@"lat"]];
    model.servicePhone = dic[@"servicePhone"];
    model.mid = [NSString stringWithFormat:@"%@",dic[@"mid"]];
    model.pid = [NSString stringWithFormat:@"%@",dic[@"pid"]];
    model.url = dic[@"url"];
    model.mintroduction = dic[@"mintroduction"];

    return model;
}


@end
