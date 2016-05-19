//
//  rightDownLocationBtn.h
//  YKY
//
//  Created by 肖亮 on 15/12/14.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface rightDownLocationBtn : NSObject

+(void)addLocationBtnWithSuperView:(UIScrollView *)scrollView andLeftView:(UILabel*)leftLabel andAction:(SEL)action andViewController:(UIViewController *)VC;

@end
