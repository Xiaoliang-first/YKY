//
//  netWorking.m
//  YKY
//
//  Created by 亮肖 on 15/6/6.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "netWorking.h"
#import "AFNetworking.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"

@implementation netWorking
+(void)loadWithVC:(UIViewController *)VC andUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters secu:(success)sec
{
    NSString *str = [kbaseURL stringByAppendingString:urlStr];
    
    AFHTTPRequestOperationManager * manger=[AFHTTPRequestOperationManager manager];

    
    [manger PUT:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sec) {
            sec(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:VC.view animated:YES];
        [MBProgressHUD showError:@"网络加载超时,请检查网络!"];
    }];
}

@end
