//
//  homeMyYGLuckNumModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/22.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeMyYGLuckNumModel.h"

@implementation homeMyYGLuckNumModel


+(instancetype)modelWithDict:(NSDictionary *)dict{
    homeMyYGLuckNumModel * model = [[homeMyYGLuckNumModel alloc]init];

    model.time = [NSString stringWithFormat:@"%@",dict[@"time"]];
    model.unum = [NSString stringWithFormat:@"%@",dict[@"joinCount"]];
    NSString * nums = [NSString stringWithFormat:@"%@",dict[@"uno"]];

    NSArray * array = [[NSArray alloc]init];
    array = [nums componentsSeparatedByString:@","];

    NSMutableArray * mutab = [NSMutableArray array];
    for (NSString * str in array) {
        int num = [str intValue];
        NSString* str1 = [NSString stringWithFormat:@"%d",num+10000000];
        [mutab addObject:str1];
    }
    model.luckNums = [NSArray arrayWithArray:mutab];
    
    return model;
}


@end
