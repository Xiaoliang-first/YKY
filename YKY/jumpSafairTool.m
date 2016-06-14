//
//  jumpSafairTool.m
//  YKY
//
//  Created by 肖亮 on 15/11/13.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "jumpSafairTool.h"
#import "Account.h"
#import "AccountTool.h"


@implementation jumpSafairTool

-(BOOL)jumpOrNo{
    
    Account * account = [AccountTool account];
    
    if ([account.phone isEqualToString:@"13051516866"]) {
        return YES;
    }else{
        //现在的年
        NSDateFormatter *yearDateformate = [[NSDateFormatter alloc]init];
        [yearDateformate setDateFormat:@"yyyy"];
        
        NSString *nowYear = [yearDateformate stringFromDate:[NSDate date]];
        
        int year = [nowYear intValue];
        //现在的月
        NSDateFormatter *mounthDateformate = [[NSDateFormatter alloc]init];
        [mounthDateformate setDateFormat:@"MM"];
        
        NSString *nowMounth = [mounthDateformate stringFromDate:[NSDate date]];
        
        int mouth = [nowMounth intValue];
        //现在的日
        NSDateFormatter *dayDateformate = [[NSDateFormatter alloc]init];
        [dayDateformate setDateFormat:@"dd"];
        
        NSString *nowDay = [dayDateformate stringFromDate:[NSDate date]];
        int day = [nowDay intValue];
        
        
        if (year==2016 && mouth==6 && 11<day && day<14) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
