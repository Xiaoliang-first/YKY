//
//  homeNewScuessDetailLuckerView.h
//  YKY
//
//  Created by 肖 亮 on 16/4/21.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeNewScuessDetailLuckerView : NSObject



+(UIView*)addViewWithFrame:(CGRect)frame toView:(UIView*)backViuew VC:(UIViewController*)VC JisuanAction:(SEL)action headUrlStr:(NSString*)headUrlStr uname:(NSString*)uname luckTimeStr:(NSString*)luckTimeStr joinTimeStr:(NSString*)joinTimeStr luckNumStr:(NSString*)luckNumStr serials:(NSString*)serials;

@end
