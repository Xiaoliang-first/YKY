//
//  YGBannerModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/20.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGBannerModel.h"

@implementation YGBannerModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    YGBannerModel * model = [[YGBannerModel alloc]init];
    model.ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    model.banner = [NSString stringWithFormat:@"%@",dict[@"banner"]];

    return model;
}


@end
