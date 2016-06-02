//
//  boundCells.h
//  YKY
//
//  Created by 肖亮 on 15/9/9.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@class unUsedPrizeModel;

@interface boundCells : UITableViewCell

/** id不为空表示是从扫描列表进来的 */
@property (nonatomic , copy) NSString * ID;

@property (weak, nonatomic) IBOutlet UIImageView *prizeImageView;
@property (weak, nonatomic) IBOutlet UILabel *bossNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *useBtn;

@property (nonatomic ) CGFloat index;

/** 列表数据模型 */
@property (nonatomic , strong) unUsedPrizeModel * model;


@end
