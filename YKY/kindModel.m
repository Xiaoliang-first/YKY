//
//  kindModel.m
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "kindModel.h"

@implementation kindModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    kindModel * model = [[kindModel alloc]init];
    
    model.kindId = [NSString stringWithFormat:@"%@",dict[@"tid"]];
    model.kindName = dict[@"tname"];
    
    return model;
}

@end
