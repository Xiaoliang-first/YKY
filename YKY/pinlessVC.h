//
//  pinlessVC.h
//  YKY
//
//  Created by 肖亮 on 15/10/15.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface pinlessVC : UIViewController

/** 第三方平台 2.微信 3.新浪 1.qq */
@property (nonatomic , copy) NSString * registType;

@property (nonatomic , strong) UMSocialAccountEntity * snsAccount;

/** 电话号码 */
@property (nonatomic , copy) NSString * phoneNumber;

@end
