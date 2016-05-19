//
//  Account.m
//  HLQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 hyqy. All rights reserved.
//


// /** 用户ID */
//@property(nonatomic,copy)NSString *uiId;
///** 用户电话账户 */
//@property(nonatomic,copy)NSString *phone;
///** 登陆结果提示信息 */
//@property(nonatomic,copy)NSString *msg;
///** gold为当前用户金币数量 */
//@property(nonatomic,assign)NSInteger *gold;
///** silverCoin为当前用户银币数量 */
//@property(nonatomic,copy)NSString *silverCoin;


#import "Account.h"

@implementation Account
+(instancetype)accountWithDict:(NSDictionary *)dict
{
    Account *info = [[Account alloc]init];
    info.uiId = [NSString stringWithFormat:@"%@",dict[@"uid"]];
    info.phone = dict[@"phone"];
    info.gold = [NSString stringWithFormat:@"%@",dict[@"gold"]];
    info.silverCoin = [NSString stringWithFormat:@"%@",dict[@"silver"]];
    info.diamonds = [NSString stringWithFormat:@"%@",dict[@"diamonds"]];
    info.reponseToken = dict[@"reponseToken"];
    
    return info;
}


//从文件解析对象的时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.uiId = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"uid"]];
        self.phone = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"phone"]];
        self.gold = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"gold"]];
        self.silverCoin = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"silver"]];
        self.reponseToken = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"reponseToken"]];
        self.diamonds = [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"diamonds"]];
    }
    return self;
}
//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uiId forKey:@"uid"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.gold forKey:@"gold"];
    [aCoder encodeObject:self.diamonds forKey:@"diamonds"];
    [aCoder encodeObject:self.silverCoin forKey:@"silver"];
    [aCoder encodeObject:self.reponseToken forKey:@"reponseToken"];
    [aCoder encodeObject:self forKey:@"code"];
}
@end
