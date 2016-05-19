//
//  messageCenterDetailVC.h
//  YKY
//
//  Created by 肖亮 on 15/9/14.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageCenterDetailVC : UIViewController

/** 标题Label */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 时间Label */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 正文Label */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@property (nonatomic , copy) NSString * TitleStr;
@property (nonatomic , copy) NSString * time;
@property (nonatomic , copy) NSString * content;

@end
