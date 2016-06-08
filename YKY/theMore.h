//
//  theMore.h
//  YKY
//
//  Created by 肖 亮 on 16/1/4.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class homeVC;
@interface theMore : NSObject

+(UIView*)addTheMoreViewWithY:(CGFloat)Y andVc:(homeVC*)VC andAction:(SEL)action;

@end
