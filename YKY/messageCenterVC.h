//
//  messageCenterVC.h
//  YKY
//
//  Created by 肖亮 on 15/9/14.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageCenterVC : UITableViewController

/** 判断是不是从推送信息进来的 1:是，2:不是 */
@property (nonatomic ,copy) NSString * ID;


@end
