//
//  bossAccount.m
//  YKY
//
//  Created by 亮肖 on 15/5/19.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "bossAccount.h"

@implementation bossAccount


+ (instancetype)bossWithDict:(NSDictionary *)dict{
    
    bossAccount *info = [[bossAccount alloc]init];

    info.mloginname = dict[@"mloginname"];
    info.supplierId = [NSString stringWithFormat:@"%@",dict[@"mid"]];
    
    return info;
}

//从文件解析对象的时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.mloginname = [aDecoder decodeObjectForKey:@"mloginname"];
        self.supplierId = [aDecoder decodeObjectForKey:@"mid"];
    }
    return self;
}
//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mloginname forKey:@"mloginname"];
    [aCoder encodeObject:self.supplierId forKey:@"mid"];
}

@end
