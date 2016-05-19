//
//  myGold.m
//  YKY
//
//  Created by 肖 亮 on 16/5/1.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "myGold.h"

@implementation myGold

+(instancetype)modelWithDict:(NSDictionary *)dict{
    myGold * model = [[myGold alloc]init];

    model.pname = [NSString stringWithFormat:@"%@",dict[@"pname"]];
    model.serials = [NSString stringWithFormat:@"%@",dict[@"serials"]];

    return model;
}

@end
