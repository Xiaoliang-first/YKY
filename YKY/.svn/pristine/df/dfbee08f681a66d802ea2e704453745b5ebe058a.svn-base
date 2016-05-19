//
//  baseRequest.m
//  YKY
//
//  Created by 亮肖 on 15/5/27.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "baseRequest.h"
#import "Account.h"
#import "AccountTool.h"

@implementation baseRequest

-(NSDictionary *)dictWithParametes:(int)page BOOL:(BOOL)Bool{
    
    Account *account = [AccountTool account];
    if (account == nil) {
        return _paremeters;
    }
    self.paremeters = [[NSMutableDictionary alloc]init];
    
    if (page >= 0) {
        self.paremeters = [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSString stringWithFormat:@"%d",page]}];
    }
    if (Bool == YES){
        [self.paremeters addEntriesFromDictionary:@{@"uiId":account.uiId,@"phone":account.phone,@"reponseToken":account.reponseToken}];
    }
    return _paremeters;
}

@end
