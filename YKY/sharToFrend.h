//
//  sharToFrend.h
//  YKY
//
//  Created by 肖亮 on 15/12/15.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface sharToFrend : NSObject<UMSocialUIDelegate>


/** 奖兜分享 */
+(void)shareWithImgurl:(NSString*)imgurl title:(NSString*)title andPid:(NSString *)pid phone:(NSString*)phone andVC:(UIViewController*)VC;

/** 推荐好友专用推荐分享接口 */
+(void)shareWithUrl:(NSString*)imgurl title:(NSString*)title name:(NSString*)name andQRImage:(UIImage *)image phone:(NSString*)phone andVC:(UIViewController*)VC;

/** 幸运兜分享接口 */
+(void)shareWithImgurl:(NSString*)imgUrl title:(NSString*)title andPid:(NSString *)pid andVC:(UIViewController*)VC;

@end
