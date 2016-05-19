//
//  meAdressModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/18.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meAdressModel.h"

@implementation meAdressModel


+(instancetype)modelWithDict:(NSDictionary *)dict{
    meAdressModel * model = [[meAdressModel alloc]init];
    model.name = [NSString stringWithFormat:@"%@",dict[@"rname"]];
    model.phone = [NSString stringWithFormat:@"%@",dict[@"rphone"]];
    model.ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    model.adressDetail = [NSString stringWithFormat:@"%@",dict[@"raddress"]];
    model.isHost = [NSString stringWithFormat:@"%@",dict[@"isdefault"]];
    return model;
}

@end
