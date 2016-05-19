//
//  NumberModel.m
//  YKY
//
//  Created by 肖亮 on 15/11/10.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "NumberModel.h"

@implementation NumberModel


+(instancetype)modelWithDict:(NSDictionary *)dict{
    
    NumberModel *info = [[NumberModel alloc]init];
    info.type = dict[@"type"];
    info.prizeId = dict[@"prizeId"];
    NSString * str = dict[@"clickNum"];
    info.clickNum = [str intValue];
    return info;
}

//从文件解析对象的时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.prizeId = [aDecoder decodeObjectForKey:@"prizeId"];
        NSString * str = [aDecoder decodeObjectForKey:@"clickNum"];
        self.clickNum = [str intValue];
    }
    return self;
}

//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.prizeId forKey:@"prizeId"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", self.clickNum] forKey:@"clickNum"];
}


@end
