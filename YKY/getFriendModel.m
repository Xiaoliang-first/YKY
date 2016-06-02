//
//  getFriendModel.m
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getFriendModel.h"

@implementation getFriendModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    getFriendModel * model = [[getFriendModel alloc]init];
    model.phone = [NSString stringWithFormat:@"%@",dict[@"registerPhone"]];
    model.signTime = [NSString stringWithFormat:@"%@",dict[@"time"]];
    model.diamondsNum = [NSString stringWithFormat:@"%@",dict[@"giveNumber"]];
    model.type = [NSString stringWithFormat:@"%@",dict[@"giveType"]];

    return model;
}

@end
