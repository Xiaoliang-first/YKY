//
//  YGPrizeDetailVC.h
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//





///////////////摇购详情里边的奖品详情-连接到H5界面///////////////

#import <UIKit/UIKit.h>


@interface YGPrizeDetailVC : UIViewController

/** 是否推送进来  1:是  0&nil：不是 */
@property (nonatomic , copy) NSString * ID;

/** 界面title */
@property (nonatomic , copy) NSString * vcTitle;

/** 请求连接url */
@property (nonatomic , strong) NSURL * requestUrl;


@end
