//
//  noticeDetailVC.h
//  一块摇
//
//  Created by 亮肖 on 15/4/27.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class noticeModel;
@interface noticeDetailVC : UIViewController

/**
 *  详情信息Label
 */
//@property (strong, nonatomic)  UILabel *noticeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeDetailLabel;

@property (nonatomic , strong) noticeModel * noticemodel;


@end
