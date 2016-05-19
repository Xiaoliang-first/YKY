//
//  homeTableViewCell.h
//  YKY
//
//  Created by 肖亮 on 15/9/8.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class prizeModel;
@interface homeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rockNumlayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prizeNumLayout;

/** 奖品图片imageview */
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
/** 商家名字的Label */
@property (weak, nonatomic) IBOutlet UILabel *bossNameLabel;
/** 奖品名字Label */
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
/** 奖品价格Label */
@property (weak, nonatomic) IBOutlet UILabel *prizePriceLabel;
/** 奖品总数量 */
@property (weak, nonatomic) IBOutlet UILabel *prizeNumberLabel;
/** 已摇出的奖品数量 */
@property (weak, nonatomic) IBOutlet UILabel *rockedNumberLabel;



/** 首页奖品模型 */
@property (nonatomic , strong) prizeModel * prizemodel;




@property (weak, nonatomic) IBOutlet UILabel *shuliang;

@property (weak, nonatomic) IBOutlet UILabel *yiyaochu;



@end
