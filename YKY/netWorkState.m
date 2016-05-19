//
//  netWorkState.m
//  YKY
//
//  Created by 肖 亮 on 16/4/25.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "netWorkState.h"

@implementation netWorkState


// 是否WIFI
+ (BOOL)isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)netWorkChange{
    if ([netWorkState isEnableWIFI]) {
//        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"温馨提示您" message:@"您现在网络环境为wifi！开始畅享吧！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alter show];
        return YES;
    } else if ([netWorkState isEnable3G]) {
//        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"温馨提示您"  message:@"您现在网络环境为3G/4G网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alter show];
        return YES;
    } else {
//        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"温馨提示您" message:@"您当前没有可连的网络或已经掉线！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alter show];
        return NO;
    }
}



@end
