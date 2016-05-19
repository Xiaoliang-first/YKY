//
//  meZhanghaoVC.h
//  YKY
//
//  Created by 肖 亮 on 16/4/14.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@class userInfo;
@interface meZhanghaoVC : UIViewController

@property (nonatomic , copy) NSString * userName;
@property (nonatomic , strong) NSURL * iconUrl;
@property (nonatomic , strong) userInfo * userModel;




@end
