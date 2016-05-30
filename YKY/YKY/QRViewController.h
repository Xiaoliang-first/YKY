//
//  QRViewController.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRUrlBlock)(NSString *url);

@interface QRViewController : UIViewController

/** 1：标示是首页进入的。其他是商家登陆端进入的 */
@property (nonatomic , copy) NSString * ID;

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;


@end
