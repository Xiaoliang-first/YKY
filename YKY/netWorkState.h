//
//  netWorkState.h
//  YKY
//
//  Created by 肖 亮 on 16/4/25.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface netWorkState : NSObject

/**
 *  是否WIFI
 */
+ (BOOL)isEnableWIFI;

/**
 *  是否3G
 */
+ (BOOL)isEnable3G;


+ (BOOL)netWorkChange;

@end
