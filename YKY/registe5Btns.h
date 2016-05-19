//
//  registe5Btns.h
//  YKY
//
//  Created by 肖亮 on 15/12/14.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface registe5Btns : NSObject

/**
 *  添加签到有关的控件
 *
 *  @param VC          要添加到的控制器
 *  @param day         上次签到成功的日期（天）
 *  @param registArray 从后台获取到的签到所需数据模型数组
 */
+(void)addToVC:(UIViewController*)VC;

/**
 *  消除所有签到有关的控件
 */
+(void)dissMess;

+(void)setSilverswithText:(NSString*)text;

@end
