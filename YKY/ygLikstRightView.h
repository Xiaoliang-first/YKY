//
//  ygLikstRightView.h
//  YKY
//
//  Created by 肖 亮 on 16/4/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ygLikstRightView : UIView

+(void)addRightViewWithArray:(NSArray*)array view:(UIView*)view frame:(CGRect)frame VC:(UIViewController*)vc action:(SEL)action;

@end
