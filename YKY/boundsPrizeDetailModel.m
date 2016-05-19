//
//  boundsPrizeDetailModel.m
//  YKY
//
//  Created by 肖 亮 on 16/3/8.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "boundsPrizeDetailModel.h"

@implementation boundsPrizeDetailModel

+(instancetype)modelWithDict:(NSDictionary *)dic{

    boundsPrizeDetailModel * model = [[boundsPrizeDetailModel alloc]init];

    model.mname = dic[@"mname"];
    model.marketPrice = [NSString stringWithFormat:@"%@",dic[@"marketPrice"]];
    model.address = dic[@"address"];
    model.introduction = dic[@"introduction"];
    model.pname = dic[@"pname"];
    model.lng = [NSString stringWithFormat:@"%@",dic[@"lng"]];
    model.lat = [NSString stringWithFormat:@"%@",dic[@"lat"]];
    model.servicePhone = dic[@"servicePhone"];
    model.mid = [NSString stringWithFormat:@"%@",dic[@"mid"]];
    model.pid = [NSString stringWithFormat:@"%@",dic[@"pid"]];
    model.url = dic[@"url"];
    model.instructions = dic[@"instructions"];
    model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
    model.etime = [NSString stringWithFormat:@"%@",dic[@"etime"]];
    model.couponsCode = dic[@"couponsCode"];


    return model;
}


@end
