//
//  btnsModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "btnsModel.h"

@implementation btnsModel

+(instancetype)modeWithDict:(NSDictionary *)dict{

    btnsModel * model = [[btnsModel alloc]init];
    model.title = dict[@"title"];
    model.identify = dict[@"identify"];

    return model;
}

@end
