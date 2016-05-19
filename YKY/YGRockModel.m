//
//  YGRockModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/23.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGRockModel.h"

@implementation YGRockModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    YGRockModel *model = [[YGRockModel alloc]init];
    model.restNum = [NSString stringWithFormat:@"%@",dict[@"restNum"]];
    model.diamonds = [NSString stringWithFormat:@"%@",dict[@"diamonds"]];
    NSString * nums = [NSString stringWithFormat:@"%@",dict[@"uno"]];
    NSArray * array = [[NSArray alloc]init];
    array = [nums componentsSeparatedByString:@","];

//    NSMutableArray * mutab = [NSMutableArray array];
//    for (NSString * str in array) {
//        long str1 = 10000000+[str intValue];
//        NSString *str2 = [NSString stringWithFormat:@"%ld",str1];
//        [mutab addObject:str2];
//    }
    model.uno = [NSArray arrayWithArray:array];
    return model;
}


@end
