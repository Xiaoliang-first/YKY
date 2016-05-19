//
//  YGCurrentyaogouListModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/11.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGCurrentyaogouListModel.h"

@implementation YGCurrentyaogouListModel

+(instancetype)modeWithDict:(NSDictionary *)dict{

    YGCurrentyaogouListModel * model = [[YGCurrentyaogouListModel alloc]init];
    model.luckDate = [NSString stringWithFormat:@"出奖时间:%@",dict[@"time"]];
    model.luckerCity = [NSString stringWithFormat:@"（%@）",dict[@"ipAddress"]];
    model.luckerIconUrlstr = [NSString stringWithFormat:@"%@",dict[@"headImage"]];
    model.luckerName = [NSString stringWithFormat:@"%@",dict[@"uname"]];
    model.luckerRockNum = [NSString stringWithFormat:@"%@",dict[@"unum"]];


    return model;
}

@end
