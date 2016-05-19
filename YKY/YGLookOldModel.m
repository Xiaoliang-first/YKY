//
//  YGLookOldModel.m
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGLookOldModel.h"

@implementation YGLookOldModel

+(instancetype)modelWithDict:(NSDictionary *)dict{
    YGLookOldModel * model = [[YGLookOldModel alloc]init];
    model.num = [NSString stringWithFormat:@"%@",dict[@"serials"]];
    model.serialId = [NSString stringWithFormat:@"%@",dict[@"serialId"]];
    return model;
}

@end
