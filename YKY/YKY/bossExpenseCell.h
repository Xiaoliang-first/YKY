//
//  bossExpenseCell.h
//  YKY
//
//  Created by 亮肖 on 15/6/30.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class bossLookConsumeListModel;
@interface bossExpenseCell : UITableViewCell

/** 奖品名字 */
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *codeL;





@property (nonatomic , strong) bossLookConsumeListModel * model;


@end
